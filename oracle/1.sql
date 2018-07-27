CREATE OR REPLACE PACKAGE PKG_SB_ZDSY_BJJY IS
  /*
    Author  : wyq
    Created : 2017-02-28
    Purpose :重点税源表间校验
     
     
   1、修改时间：20170915
      修改人：wyq
      修改问题：1)将税收表中temqyjbxx1变量的定义大小增加到100；
                2)将对D77的验证or修改为and
                3)规范传入及输出参数命名格式，删除部分无用变量
                
   2、修改时间：20170921
      修改人：wyq
      修改问题：1)将税收表中v_qyssxx_baseROW变量修改为-2，和行次对应上；
      
   3、修改时间：20170925
      修改人：wyq
      修改问题：1)统一规范修改自定义变量名称；
      
   4、修改时间：20171024
      修改人：wyq
      修改问题：1)修改税收表SH00000196，SH00000197表间校验逻辑；
                2)修改税收表SH00000133表间校验逻辑；
   
   5、修改时间：20171027
      修改人：wyq
      修改问题：1)在每个审核公式判断前添加v_flag置0标记
      
   5、修改时间：20180314
      修改人：wyq
      修改问题：1)根据2018年基本信息表代码值的更新，修改校验公式  
      
  */

  procedure P_SB_ZDSY_BBZL(i_nsrlx_date in varchar2,
                           i_nsrsbh     in varchar2,
                           i_sbrq_q     in varchar2,
                           i_sbrq_z     in varchar2,
                           o_shgs       out varchar2,
                           o_shsm       out varchar2,
                           o_shbj       out CLOB);
  procedure P_SB_ZDSY_BJJY_MAIN(i_server_date IN VARCHAR2,
                                i_nsrlx_dm    in varchar2,
                                i_nsrsbh      in varchar2,
                                i_sbrq_q      in varchar2,
                                i_sbrq_z      in varchar2,
                                o_shgs        out varchar2,
                                o_shsm        out varchar2,
                                o_shbj        out CLOB);
  procedure P_SB_BJJY_CWBB(i_nsrsbh  IN VARCHAR2, --纳税人识别号
                           i_sssq_q  IN VARCHAR2, --所属时期起
                           i_sssq_z  IN VARCHAR2, --所属时期止
                           o_retSHGS OUT VARCHAR2, --返回审核公式
                           o_retSHSM OUT VARCHAR2, --返回审核提示信息
                           o_retSHBJ OUT CLOB --返回审核标记
                           );
  procedure P_SB_BJJY_QYSSXX(i_nsrsbh  IN VARCHAR2, --纳税人识别号
                             i_sssq_q  IN VARCHAR2, --所属时期起
                             i_sssq_z  IN VARCHAR2, --所属时期止
                             o_retSHGS OUT VARCHAR2, --返回审核公式
                             o_retSHSM OUT VARCHAR2, --返回审核提示信息
                             o_retSHBJ OUT CLOB --返回审核标记
                             );
  procedure P_SB_BJJY_CPSSB(i_nsrsbh  IN VARCHAR2, --纳税人识别号
                            i_sssq_q  IN VARCHAR2, --所属时期起
                            i_sssq_z  IN VARCHAR2, --所属时期止
                            o_retSHGS OUT VARCHAR2, --返回审核公式
                            o_retSHSM OUT VARCHAR2, --返回审核提示信息
                            o_retSHBJ OUT CLOB --返回审核标记
                            );
  procedure P_SB_BJJY_QYJBXX(i_nsrsbh  IN VARCHAR2, --纳税人识别号
                             i_sssq_q  IN VARCHAR2, --所属时期起
                             i_sssq_z  IN VARCHAR2, --所属时期止
                             o_retSHGS OUT VARCHAR2, --返回审核公式
                             o_retSHSM OUT VARCHAR2, --返回审核提示信息
                             o_retSHBJ OUT CLOB --返回审核标记
                             );
  procedure P_SB_BJJY_JQDCWJ(i_server_date IN VARCHAR2,
                             i_nsrsbh      IN VARCHAR2, --纳税人识别号
                             i_sssq_q      IN VARCHAR2, --所属时期起
                             i_sssq_z      IN VARCHAR2, --所属时期止
                             o_retSHGS     OUT VARCHAR2, --返回审核公式
                             o_retSHSM     OUT VARCHAR2, --返回审核提示信息
                             o_retSHBJ     OUT CLOB --返回审核标记
                             );

-----------------------------------------------------------------------

END PKG_SB_ZDSY_BJJY;
/

create or replace package body PKG_SB_ZDSY_BJJY is


  --根据申报日期起止判断季末报季初报月报
  
  procedure P_SB_ZDSY_BBZL( i_nsrlx_date in varchar2,i_nsrsbh in varchar2,
                            i_sbrq_q in varchar2,
                            i_sbrq_z in varchar2,
                            o_shgs out varchar2,
                            o_shsm out varchar2,
                            o_shbj out CLOB) is
     v_server_date   VARCHAR2(20);
     v_nsrlxs varchar2(100);
  begin

SELECT to_char(WM_CONCAT(nsrlx_dm)) into v_nsrlxs from Table(P_GET_ZDSY_NSRLX(i_nsrlx_date));
    --表间校验
 P_SB_ZDSY_BJJY_MAIN(i_nsrlx_date,v_nsrlxs,i_nsrsbh,i_sbrq_q, i_sbrq_z,o_shgs,o_shsm,o_shbj);
-- P_SB_ZDSY_BJJY_MAIN('2017-08-01','6010010','91411600175411119J','2017-07-01','2017-07-31',o_shgs,o_shsm,o_shbj);
   -- P_SB_ZDSY_BJJY_MAIN(v_server_date,'6010030','91410000170001401D','2017-03-01','2017-05-31',o_shgs,o_shsm,o_shbj);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      o_shgs := '-1';
      o_shsm := '-1';
      o_shbj := '-1';
      dbms_output.put_line('**Error line:' ||
                           dbms_utility.format_error_backtrace());
      dbms_output.put_line('**Error code:' || SQLCODE);
      dbms_output.put_line('**Error info:' || SQLERRM);
      return;
  END P_SB_ZDSY_BBZL;



  --表间校验
  procedure P_SB_ZDSY_BJJY_MAIN(i_server_date  in VARCHAR2,
                               i_nsrlx_dm     in varchar2,
                               i_nsrsbh     in varchar2,
                               i_sbrq_q      in varchar2,
                               i_sbrq_z      in varchar2,
                               o_shgs       out varchar2,
                               o_shsm       out varchar2,
                               o_shbj       out CLOB) is
     v_shgs    CLOB:='';  --返回审核公式
     v_shsm    CLOB:='';  --返回审核提示信息
     v_shbj    CLOB:='';  --返回审核标记
     v_split   CLOB := ',';
 begin

--to_char(WM_CONCAT(nsrlx_dm))



IF  instr(i_nsrlx_dm,'6010010',1)>0 THEN

      P_SB_BJJY_QYSSXX(i_nsrsbh,i_sbrq_q,i_sbrq_z,v_shgs,v_shsm,v_shbj); --税收表校验
      o_shgs := o_shgs || v_shgs;
      o_shsm := o_shsm || v_shsm;
      o_shbj := o_shbj || v_shbj;

      P_SB_BJJY_CPSSB(i_nsrsbh,i_sbrq_q,i_sbrq_z,v_shgs,v_shsm,v_shbj); --产品表校验
      o_shgs := o_shgs || v_shgs;
      o_shsm := o_shsm || v_shsm;
      o_shbj := o_shbj || v_shbj;

      P_SB_BJJY_QYJBXX(i_nsrsbh,i_sbrq_q,i_sbrq_z,v_shgs,v_shsm,v_shbj); --基本信息表校验
      o_shgs := o_shgs || v_shgs;
      o_shsm := o_shsm || v_shsm;
      o_shbj := o_shbj || v_shbj;

END IF;

IF  instr(i_nsrlx_dm,'6010020',1)>0 THEN
      P_SB_BJJY_CWBB(i_nsrsbh,i_sbrq_q,i_sbrq_z,v_shgs,v_shsm,v_shbj); --财务表校验
      o_shgs := o_shgs || v_shgs;
      o_shsm := o_shsm || v_shsm;
      o_shbj := o_shbj || v_shbj;

END IF;

IF  instr(i_nsrlx_dm,'6010030',1)>0 THEN
  P_SB_BJJY_JQDCWJ(i_server_date,i_nsrsbh,i_sbrq_q,i_sbrq_z,v_shgs,v_shsm,v_shbj); --调查问卷校验
      o_shgs := o_shgs || v_shgs;
      o_shsm := o_shsm || v_shsm;
      o_shbj := o_shbj || v_shbj;
      
      --o_shbj := 'SH00000095,SH00000107,SH00000117';
END IF;
 --o_shbj := 'SH00000095,SH00000107,SH00000117';
--DBMS_OUTPUT.PUT_LINE(dbms_lob.substr(o_shbj,8000,1));
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      o_shgs := '-1';
      o_shsm := '-1';
      o_shbj := '-1';
      dbms_output.put_line('**Error line:' ||
                           dbms_utility.format_error_backtrace());
      dbms_output.put_line('**Error code:' || SQLCODE);
      dbms_output.put_line('**Error info:' || SQLERRM);
      return;
  END P_SB_ZDSY_BJJY_MAIN;

  ---------------------------------------------------------------------------------------------------
  --=================================================================================================
  ---------------------------以下方法为：企业财务报表---------------------------------------------
  --=================================================================================================
  ---------------------------------------------------------------------------------------------------

  --企业财务报表校验
  procedure P_SB_BJJY_CWBB(
     i_nsrsbh   IN       VARCHAR2,--纳税人识别号
   i_sssq_q   IN       VARCHAR2,--所属时期起
   i_sssq_z   IN       VARCHAR2,--所属时期止
   o_retSHGS     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHSM     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHBJ     OUT      CLOB  --返回检查结果，如果有空字符或者字符串长度为0
)
is

   type t_sb_zdsy_cwxx_rowtype is table of sb_zdsy_cwxx%rowtype index by binary_integer; --定义财务信息表类型
   type t_sb_zdsy_qyssxx_rowtype is table of sb_zdsy_qyssxx%rowtype index by binary_integer; --定义企业税收信息表类型
   type t_sb_zdsy_cpssb_rowtype is table of sb_zdsy_cpssb%rowtype index by binary_integer; --定义主要产品税收表类型
   type t_sb_zdsy_qyjbxx_rowtype is table of sb_zdsy_qyjbxx%rowtype index by binary_integer; --定义基本信息表类型
   type t_sb_zdsy_jqdcwj_rowtype is table of sb_zdsy_jqdcwj%rowtype index by binary_integer; --定义调查问卷表类型

   v_sb_zdsy_cwxx t_sb_zdsy_cwxx_rowtype;--定义财务信息表变量
   v_sb_zdsy_qyssxx t_sb_zdsy_qyssxx_rowtype;--定义企业税收信息表变量
   v_sb_zdsy_cpssb t_sb_zdsy_cpssb_rowtype;--定义主要产品税收表变量
   v_sb_zdsy_qyjbxx t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量
   v_sb_zdsy_jqdcwj t_sb_zdsy_jqdcwj_rowtype;--定义调查问卷表变量


   v_wcfw INT DEFAULT 0;         --误差范围为1元, 2017.01.07不允许误差，设定误差为0
   v_temcwxx1              NUMBER (16, 2);--财务信息表变量
   v_temcwxx2              NUMBER (16, 2);--财务信息表变量
   v_temcwxx3              NUMBER (16, 2);--财务信息表变量
   v_temcwxx4              NUMBER (16, 2);--财务信息表变量
   v_temcwxx5              NUMBER (16, 2);--财务信息表变量
   v_temcwxx6              NUMBER (16, 2);--财务信息表变量
   v_temcwxx7              NUMBER (16, 2);--财务信息表变量
   v_temcwxx8              NUMBER (16, 2);--财务信息表变量
   v_temqyssxx            NUMBER (16, 2);--企业税收信息表变量
   v_temcpssb             NUMBER (16, 2);--主要产品税收表变量
   v_temqyjbxx            NUMBER (16, 2);--基本信息表变量
   v_temqyjbxx1            NUMBER (16, 2);--基本信息表变量
   v_temqyjbxx_str                   varchar2(20);
   v_temjqdcwj            NUMBER (16, 2);--调查问卷表变量
   v_qyjbxx_baseROW           NUMBER;
   v_cwxx_baseROW        NUMBER;
   v_split                   varchar2(10) := ',';
   v_flag varchar2(1) := 0;--用于标记是否保存过该公式
BEGIN

v_qyjbxx_baseROW:=0;
v_cwxx_baseROW:=0;


   select * bulk collect into v_sb_zdsy_cwxx --给财务信息表变量赋值
     from sb_zdsy_cwxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyssxx --给企业税收信息表变量赋值
     from sb_zdsy_qyssxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_cpssb --给主要产品税收表变量赋值
     from sb_zdsy_cpssb t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyjbxx --给基本信息表变量赋值
     from sb_zdsy_qyjbxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_jqdcwj --给调查问卷表变量赋值
     from sb_zdsy_jqdcwj t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;


/****
************************************************************************************
********************************财务信息表表间校验*************************************
************************************************************************************
****/
/***
2. (([C4,D4]<>0)&([C4,D4]<>null)&([C7,D7]<>0)&([C7,D7]<>null)) | ((([C4,D4]=0)|([C4,D4]=null)) & (([C7,D7]=0)|([C7,D7]=null))) | (%JB%) | (XXB->E11="3")
【国】【地】主营业务收入有数时，主营业务成本也应该有数；反之主营业务成本有数时，主营业务收入也应有数！如有特殊情况，请填写审核说明！
SH00000209 true
**/

if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col01,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+7).col01,0);
         if ((v_temcwxx1 = 0 or v_temcwxx1 is null or v_temcwxx2 = 0 or v_temcwxx2 is null) and ((v_temcwxx1 <> 0 and v_temcwxx1 is not null) or (v_temcwxx2 <> 0 and v_temcwxx2 is not null)) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             ----o_retSHGS := o_retSHGS || '(([C4,D4]<>0)&([C4,D4]<>null)&([C7,D7]<>0)&([C7,D7]<>null))|((([C4,D4]=0)|([C4,D4]=null))&(([C7,D7]=0)|([C7,D7]=null)))|(%JB%)|(XXB->E11="3")' || v_split;
             ----o_retSHSM := o_retSHSM || '【国】免抵退货物应退税额<=上期留抵税额!如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ || 'SH00000209' || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col02,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+7).col03,0);
         if ((v_temcwxx1 = 0 or v_temcwxx1 is null or v_temcwxx2 = 0 or v_temcwxx2 is null) and ((v_temcwxx1 <> 0 and v_temcwxx1 is not null) or (v_temcwxx2 <> 0 and v_temcwxx2 is not null)) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(([C4,D4]<>0)&([C4,D4]<>null)&([C7,D7]<>0)&([C7,D7]<>null))|((([C4,D4]=0)|([C4,D4]=null))&(([C7,D7]=0)|([C7,D7]=null)))|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM ||'【国】免抵退货物应退税额<=上期留抵税额!如有特殊情况，请填写审核说明！'|| v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000209'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
   end if;

end if;


/***
3.(if((C20<>0)&(D20<>0)&(C20<>NULL)&(D20<>NULL),(C3<>D3)&(C6<>D6)&(C16<>D16)&(C20<>D20),true)) |  (%JB%)  |  (XXB->E11="3")
【国】【地】利润表本期与上期不能相等！如有特殊情况，请填写审核说明！
SH00000211 true
**/

if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0; /**C3**/
   v_temcwxx2:=0; /**D3**/
   v_temcwxx3:=0; /**C6**/
   v_temcwxx4:=0; /**D6**/
   v_temcwxx5:=0; /**C16**/
   v_temcwxx6:=0; /**D16**/
   v_temcwxx7:=0; /**C20**/
   v_temcwxx8:=0; /**D20**/
   v_flag :=0;

   v_temqyjbxx:=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;

   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col01,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col02,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col01,0);
     v_temcwxx4 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col02,0);
     v_temcwxx5 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col01,0);
     v_temcwxx6 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col02,0);
     v_temcwxx7 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col01,0);
     v_temcwxx8 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col02,0);
         if ((v_temcwxx7 <> 0 and v_temcwxx7 is not null and v_temcwxx8 <> 0 and v_temcwxx8 is not null) and ((v_temcwxx1 = v_temcwxx2) or (v_temcwxx3 = v_temcwxx4) or (v_temcwxx5 = v_temcwxx6) or (v_temcwxx7 = v_temcwxx8)) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if((C20<>0)&(D20<>0)&(C20<>NULL)&(D20<>NULL),(C3<>D3)&(C6<>D6)&(C16<>D16)&(C20<>D20),true))|(%JB%)|(XXB->E11="3")'|| v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】利润表本期与上期不能相等！如有特殊情况，请填写审核说明！'|| v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000211'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
   end if;

end if;





/***
4.(if((XXB->E11="1")|(XXB->E11="2"),([C22,D22]<>0)&([C22,D22]<>null)&([H32,J32]<>0)&([H32,J32]<>null),true))|(%JB%)|(XXB->E11="3")
【国】【地】请填报财务表及资产负债表！如有特殊情况，请填写审核说明！
SH00000214 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col01,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col04,0);
         if ((v_temqyjbxx = 1 or v_temqyjbxx = 2) and (v_temcwxx1 = 0 or v_temcwxx1 is null or v_temcwxx2 = 0 or v_temcwxx2 is null) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||'(if((XXB->E11="1")|(XXB->E11="2"),([C22,D22]<>0)&([C22,D22]<>null)&([H32,J32]<>0)&([H32,J32]<>null),true))|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】请填报财务表及资产负债表！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000214'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col02,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col06,0);
         if ((v_temqyjbxx = 1 or v_temqyjbxx = 2) and (v_temcwxx1 = 0 or v_temcwxx1 is null or v_temcwxx2 = 0 or v_temcwxx2 is null) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||'(([C4,D4]<>0)&([C4,D4]<>null)&([C7,D7]<>0)&([C7,D7]<>null))|((([C4,D4]=0)|([C4,D4]=null))&(([C7,D7]=0)|([C7,D7]=null)))|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM ||'【国】免抵退货物应退税额<=上期留抵税额!如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000214'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
   end if;

end if;


/***
5.(if((XXB->E11<>"3")&(left(XXB->E4,2)<>"47")&(left(XXB->E4,2)<>"48")&(left(XXB->E4,2)<>"49")&(left(XXB->E4,2)<>"50")&(left(XXB->E4,2)<>"66")&(left(XXB->E4,2)<>"67")&(left(XXB->E4,2)<>"68")&(left(XXB->E4,2)<>"69")&(left(XXB->E4,2)<>"70")&(left(XXB->E4,2)<>"63")&(left(XXB->E4,2)<>"64")&(left(XXB->E4,2)<>"65")&((B3->C3>=100000)|(B3->D3>=100000)),((B3->C6>0)&(B3->D6>0)),TRUE))|(%JB%)

(

    if
    (
       (XXB->E11<>"3")&(left(XXB->E4,2)<>"47")&(left(XXB->E4,2)<>"48")&(left(XXB->E4,2)<>"49")&(left(XXB->E4,2)<>"50")&(left(XXB->E4,2)<>"66")&(left(XXB->E4,2)<>"67")&(left(XXB->E4,2)<>"68")&(left(XXB->E4,2)<>"69")&(left(XXB->E4,2)<>"70")&(left(XXB->E4,2)<>"63")&(left(XXB->E4,2)<>"64")&(left(XXB->E4,2)<>"65")&((B3->C3>=100000)|(B3->D3>=100000))
       ,((B3->C6>0)&(B3->D6>0))
       ,TRUE)
   )

|(%JB%)

【国】【地】财务表营业收入有数且超过10亿，营业成本无数，请核实，如有特殊情况，请填写审核说明。
SH00000215 true
**/

if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temcwxx3:=0;
   v_temcwxx4:=0;
   v_temqyjbxx:=0;
   v_temqyjbxx1:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
         v_temqyjbxx1 := nvl(substr(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01,0,2),0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col01,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col02,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col01,0);
     v_temcwxx4 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col02,0);
         if (v_temqyjbxx <> 3 and v_temqyjbxx1 <> 47 and v_temqyjbxx1 <> 48 and v_temqyjbxx1 <> 49 and v_temqyjbxx1 <> 50 and v_temqyjbxx1 <> 66 and v_temqyjbxx1 <> 67 and v_temqyjbxx1 <> 68 and v_temqyjbxx1 <> 69 and v_temqyjbxx1 <> 70 and v_temqyjbxx1 <> 63 and v_temqyjbxx1 <> 64 and v_temqyjbxx1 <> 65 and (v_temcwxx1 >= 100000*10000 or v_temcwxx2 >= 100000*10000)) then
           if (v_temcwxx3 <= 0 or v_temcwxx4 <= 0) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS ||'(if((XXB->E11<>"3")&(left(XXB->E4,2)<>"47")&(left(XXB->E4,2)<>"48")&(left(XXB->E4,2)<>"49")&(left(XXB->E4,2)<>"50")&(left(XXB->E4,2)<>"66")&(left(XXB->E4,2)<>"67")&(left(XXB->E4,2)<>"68")&(left(XXB->E4,2)<>"69")&(left(XXB->E4,2)<>"70")&(left(XXB->E4,2)<>"63")&(left(XXB->E4,2)<>"64")&(left(XXB->E4,2)<>"65")&((B3->C3>=100000)|(B3->D3>=100000)),((B3->C6>0)&(B3->D6>0)),TRUE))|(%JB%)'|| v_split;
               --o_retSHSM := o_retSHSM ||'【国】【地】财务表营业收入有数且超过10亿，营业成本无数，请核实，如有特殊情况，请填写审核说明。' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000215'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
         end if;

   end if;

end if;




/***
6.(if([H3,J3]>5000,[H3,J3]<[G3,I3]*8,true))|(%JB%)|(XXB->E11="3")
【国】【地】期初与期末数差异过大，请核实资产总计数据填写是否正确！如有特殊情况，请填写审核说明！
SH00000216 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;


   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col03,0);
         if ((v_temcwxx1 > 5000*10000) and (v_temcwxx1 >= v_temcwxx2 * 8) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||'(if([H3,J3]>5000,[H3,J3]<[G3,I3]*8,true))|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】期初与期末数差异过大，请核实资产总计数据填写是否正确！如有特殊情况，请填写审核说明！'|| v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000216'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col05,0);
         if ((v_temcwxx1 > 5000*10000) and (v_temcwxx1 >= v_temcwxx2 * 8) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if([H3,J3]>5000,[H3,J3]<[G3,I3]*8,true))|(%JB%)|(XXB->E11="3")'|| v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实资产总计数据填写是否正确！如有特殊情况，请填写审核说明！'|| v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000216'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
   end if;

end if;



/***
8.(if(([G4,H4,I4,J4]>0)&([G16,H16,I16,J16]+[G17,H17,I17,J17]+[G18,H18,I18,J18]+[G19,H19,I19,J19]+[G20,H20,I20,J20]+[G21,H21,I21,J21]>0),[G3,H3,I3,J3]>0,true))|(%JB%)|(XXB->E11="3")
【国】【地】请核实资产总计填写是否正确！如有特殊情况，请填写审核说明！
SH00000220 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temcwxx3:=0;

   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col03,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col03,0);
         if ((v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 < 0) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||'(if(([G4,H4,I4,J4]>0)&([G16,H16,I16,J16]+[G17,H17,I17,J17]+[G18,H18,I18,J18]+[G19,H19,I19,J19]+[G20,H20,I20,J20]+[G21,H21,I21,J21]>0),[G3,H3,I3,J3]>0,true))|(%JB%)|(XXB->E11="3")'|| v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】请核实资产总计填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000220'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col04,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col04,0);
         if ((v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 < 0) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if(([G4,H4,I4,J4]>0)&([G16,H16,I16,J16]+[G17,H17,I17,J17]+[G18,H18,I18,J18]+[G19,H19,I19,J19]+[G20,H20,I20,J20]+[G21,H21,I21,J21]>0),[G3,H3,I3,J3]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】请核实资产总计填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000220'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col05,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col05,0);
         if ((v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 < 0) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if(([G4,H4,I4,J4]>0)&([G16,H16,I16,J16]+[G17,H17,I17,J17]+[G18,H18,I18,J18]+[G19,H19,I19,J19]+[G20,H20,I20,J20]+[G21,H21,I21,J21]>0),[G3,H3,I3,J3]>0,true))|(%JB%)|(XXB->E11="3")'|| v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】请核实资产总计填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000220'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col06,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col06,0);
         if ((v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 < 0) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if(([G4,H4,I4,J4]>0)&([G16,H16,I16,J16]+[G17,H17,I17,J17]+[G18,H18,I18,J18]+[G19,H19,I19,J19]+[G20,H20,I20,J20]+[G21,H21,I21,J21]>0),[G3,H3,I3,J3]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】请核实资产总计填写是否正确！如有特殊情况，请填写审核说明！'|| v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000220'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
   end if;

end if;




/***
9.(if([G3,I3]>5000,[G3,I3]<[H3,J3]*8,true))|(%JB%)|(XXB->E11="3")
【国】【地】期初与期末数差异过大，请核实资产总计数据填写是否正确！如有特殊情况，请填写审核说明！
SH00000221 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col04,0);
         if ((v_temcwxx1 > 5000*10000) and (v_temcwxx1 >= v_temcwxx2 * 8) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||'(if([G3,I3]>5000,[G3,I3]<[H3,J3]*8,true))|(%JB%)|(XXB->E11="3")'|| v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】期初与期末数差异过大，请核实资产总计数据填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ || 'SH00000221' || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col06,0);
         if ((v_temcwxx1 > 5000*10000) and (v_temcwxx1 >= v_temcwxx2 * 8) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if([G3,I3]>5000,[G3,I3]<[H3,J3]*8,true))|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】期初与期末数差异过大，请核实资产总计数据填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000221'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
   end if;

end if;




/***
10.([G4,H4,I4,J4]>[G5,H5,I5,J5]+[G6,H6,I6,J6]+[G7,H7,I7,J7]+[G8,H8,I8,J8]+[G9,H9,I9,J9]+[G10,H10,I10,J10]+[G11,H11,I11,J11]+[G12,H12,I12,J12]-0.05)|(%JB%)|(XXB->E11="3")
【国】【地】流动资产合计大于等于其中项之和！如有特殊情况，请填写审核说明！
SH00000222 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temqyjbxx:=0;
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_flag :=0;

   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;

   if v_temqyjbxx <>0 and v_temqyjbxx is not null then

     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+5).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+7).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+8).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+9).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+10).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+11).col03,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col03,0);
         if ((v_temcwxx1 <= v_temcwxx2 - 500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||'([G4,H4,I4,J4]>[G5,H5,I5,J5]+[G6,H6,I6,J6]+[G7,H7,I7,J7]+[G8,H8,I8,J8]+[G9,H9,I9,J9]+[G10,H10,I10,J10]+[G11,H11,I11,J11]+[G12,H12,I12,J12]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】流动资产合计大于等于其中项之和！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000222'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+5).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+7).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+8).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+9).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+10).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+11).col04,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col04,0);
         if ((v_temcwxx1 <= v_temcwxx2 - 500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([G4,H4,I4,J4]>[G5,H5,I5,J5]+[G6,H6,I6,J6]+[G7,H7,I7,J7]+[G8,H8,I8,J8]+[G9,H9,I9,J9]+[G10,H10,I10,J10]+[G11,H11,I11,J11]+[G12,H12,I12,J12]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】流动资产合计大于等于其中项之和！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000222'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
      v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+5).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+7).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+8).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+9).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+10).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+11).col05,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col05,0);
         if ((v_temcwxx1 <= v_temcwxx2 - 500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([G4,H4,I4,J4]>[G5,H5,I5,J5]+[G6,H6,I6,J6]+[G7,H7,I7,J7]+[G8,H8,I8,J8]+[G9,H9,I9,J9]+[G10,H10,I10,J10]+[G11,H11,I11,J11]+[G12,H12,I12,J12]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】流动资产合计大于等于其中项之和！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000222'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
      v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+5).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+6).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+7).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+8).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+9).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+10).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+11).col06,0)
               + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col06,0);
         if ((v_temcwxx1 <= v_temcwxx2 - 500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([G4,H4,I4,J4]>[G5,H5,I5,J5]+[G6,H6,I6,J6]+[G7,H7,I7,J7]+[G8,H8,I8,J8]+[G9,H9,I9,J9]+[G10,H10,I10,J10]+[G11,H11,I11,J11]+[G12,H12,I12,J12]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】流动资产合计大于等于其中项之和！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000222'
                 || v_split;
             v_flag :=1;
           end if;
         end if;

   end if;

end if;





/***
11.(if(([G3,H3]<>0)&([I3,J3]<>0),([G3,H3]<>[I3,J3])&([G4,H4]<>[I4,J4])&([G22,H22]<>[I22,J22])&([G23,H23]<>[I23,J23]),true))|(%JB%)|(XXB->E11="3")
【【国】【地】资产负债表本年数与上年数不应相等！如有特殊情况，请填写审核说明！
SH00000223 true
**/

if v_sb_zdsy_cwxx.count>0 then
   v_temqyjbxx:= 0;
   v_flag :=0;


   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;

   if v_temqyjbxx <>0 and v_temqyjbxx is not null then

     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col05,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col03,0);
     v_temcwxx4 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+4).col05,0);
     v_temcwxx5 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col03,0);
     v_temcwxx6 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col05,0);
     v_temcwxx7 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+23).col03,0);
     v_temcwxx8 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+23).col05,0);

         if (v_temcwxx1 <> 0 and v_temcwxx2 <> 0) then
           if (v_temcwxx1 = v_temcwxx2 or v_temcwxx3 = v_temcwxx4 or v_temcwxx5 = v_temcwxx6 or v_temcwxx7 = v_temcwxx8 and v_temqyjbxx <> 3) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(if(([G3,H3]<>0)&([I3,J3]<>0),([G3,H3]<>[I3,J3])&([G4,H4]<>[I4,J4])&([G22,H22]<>[I22,J22])&([G23,H23]<>[I23,J23]),true))|(%JB%)|(XXB->E11="3")' || v_split;
               --o_retSHSM := o_retSHSM || '【国】【地】资产负债表本年数与上年数不应相等！如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000223'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
         end if;



   end if;

end if;




/***
12.([G12:J12]>[G13:J13]+[G14:J14]-0.05)|(%JB%)|(XXB->E11="3")
【国】【地】存货>=原材料+库存商品！如有特殊情况，请填写审核说明！
SH00000224 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temcwxx3:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col03,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col03,0);
         if ((v_temcwxx1 <= v_temcwxx2 + v_temcwxx3 -500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([G12:J12]>[G13:J13]+[G14:J14]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】存货>=原材料+库存商品！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000224'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col04,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col04,0);
         if ((v_temcwxx1 <= v_temcwxx2 + v_temcwxx3 -500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([G12:J12]>[G13:J13]+[G14:J14]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM ||  '【国】【地】存货>=原材料+库存商品！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000224'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col05,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col05,0);
         if ((v_temcwxx1 <= v_temcwxx2 + v_temcwxx3 -500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([G12:J12]>[G13:J13]+[G14:J14]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】存货>=原材料+库存商品！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000224'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col06,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col06,0);
         if ((v_temcwxx1 <= v_temcwxx2 + v_temcwxx3 -500) and (v_temqyjbxx <> 3)) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([G12:J12]>[G13:J13]+[G14:J14]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】存货>=原材料+库存商品！如有特殊情况，请填写审核说明！'  || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000224'
                 || v_split;
             v_flag :=1;
           end if;
         end if;



   end if;

end if;



/***
13.(if([G12:J12]>0,[G13:J13]+[G14:J14]>0,true))|(%JB%)|(XXB->E11="3")
【国】【地】存货>0时，其中：原材料+库存商品>0！如有特殊情况，请填写审核说明！
SH00000225 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temcwxx3:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col03,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col03,0);
         if (v_temcwxx1 > 0) then
           if (v_temcwxx2 + v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(if([G12:J12]>0,[G13:J13]+[G14:J14]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
               --o_retSHSM := o_retSHSM || '【国】【地】存货>0时，其中：原材料+库存商品>0！如有特殊情况，请填写审核说明！'  || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000225'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col04,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col04,0);
         if (v_temcwxx1 > 0) then
           if (v_temcwxx2 + v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(if([G12:J12]>0,[G13:J13]+[G14:J14]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
               --o_retSHSM := o_retSHSM ||'【国】【地】存货>0时，其中：原材料+库存商品>0！如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000225'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col05,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col05,0);
         if (v_temcwxx1 > 0) then
           if (v_temcwxx2 + v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(if([G12:J12]>0,[G13:J13]+[G14:J14]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
               --o_retSHSM := o_retSHSM || '【国】【地】存货>0时，其中：原材料+库存商品>0！如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000225'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
         end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+12).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+13).col06,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+14).col06,0);
         if (v_temcwxx1 > 0) then
           if (v_temcwxx2 + v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(if([G12:J12]>0,[G13:J13]+[G14:J14]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
               --o_retSHSM := o_retSHSM || '【国】【地】存货>0时，其中：原材料+库存商品>0！如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000225'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
         end if;


   end if;

end if;


/***
14.([G15:J15]>[G16:J16]+[G17:J17]+[G18:J18]+[G19:J19]+[G20:J20]+[G21:J21]-0.05)|(%JB%)|(XXB->E11="3")
【国】【地】其中:非流动资产合计(15=3-4)>=其中:可供出售的金融资产+投资性房地产+长期股权投资+固定资产+在建工程！如有特殊情况，请填写审核说明！
SH00000226 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+15).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col03,0);
       if (v_temcwxx1 <= v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G15:J15]>[G16:J16]+[G17:J17]+[G18:J18]+[G19:J19]+[G20:J20]+[G21:J21]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】其中:非流动资产合计(15=3-4)>=其中:可供出售的金融资产+投资性房地产+长期股权投资+固定资产+在建工程！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000226'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+15).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col04,0);
       if (v_temcwxx1 <= v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G15:J15]>[G16:J16]+[G17:J17]+[G18:J18]+[G19:J19]+[G20:J20]+[G21:J21]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】其中:非流动资产合计(15=3-4)>=其中:可供出售的金融资产+投资性房地产+长期股权投资+固定资产+在建工程！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000226'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+15).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col05,0);
       if (v_temcwxx1 <= v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G15:J15]>[G16:J16]+[G17:J17]+[G18:J18]+[G19:J19]+[G20:J20]+[G21:J21]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】其中:非流动资产合计(15=3-4)>=其中:可供出售的金融资产+投资性房地产+长期股权投资+固定资产+在建工程！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000226'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+15).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+16).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+17).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+18).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+19).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+21).col06,0);
       if (v_temcwxx1 <= v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G15:J15]>[G16:J16]+[G17:J17]+[G18:J18]+[G19:J19]+[G20:J20]+[G21:J21]-0.05)|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】其中:非流动资产合计(15=3-4)>=其中:可供出售的金融资产+投资性房地产+长期股权投资+固定资产+在建工程！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000226'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;

end if;


/***
15.(if([H22,J22]>5000,[H22,J22]<[G22,I22]*8,true))|(%JB%)|(XXB->E11="3")
【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！
SH00000230 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col03,0);
       if (v_temcwxx1 > 5000 and v_temcwxx1 >= v_temcwxx2 * 8 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if([H22,J22]>5000,[H22,J22]<[G22,I22]*8,true))|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000230'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col05,0);
       if (v_temcwxx1 > 5000 and v_temcwxx1 >= v_temcwxx2 * 8 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if([H22,J22]>5000,[H22,J22]<[G22,I22]*8,true))|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000230'
               || v_split;
           v_flag :=1;
         end if;
       end if;



   end if;

end if;


/***
16.(if([G22,I22]>5000,[G22,I22]<[H22,J22]*8,true))|(%JB%)|(XXB->E11="3")
【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！
SH00000231 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col04,0);
       if (v_temcwxx1 > 5000 and v_temcwxx1 >= v_temcwxx2 * 8 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if([G22,I22]>5000,[G22,I22]<[H22,J22]*8,true))|(%JB%)|(XXB->E11="3")'  || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000231'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col06,0);
       if (v_temcwxx1 > 5000 and v_temcwxx1 >= v_temcwxx2 * 8 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if([G22,I22]>5000,[G22,I22]<[H22,J22]*8,true))|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000231'
               || v_split;
           v_flag :=1;
         end if;
       end if;



   end if;

end if;



/***
17.(if(([G23,H23,I23,J23]>0)&([G30,H30,I30,J30]>0),[G22,H22,I22,J22]>0,true))|(%JB%)|(XXB->E11="3")
【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！
SH00000232 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temcwxx3:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+23).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+30).col03,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col03,0);
       if (v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(([G23,H23,I23,J23]>0)&([G30,H30,I30,J30]>0),[G22,H22,I22,J22]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM ||'【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000232'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+23).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+30).col04,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col04,0);
       if (v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(([G23,H23,I23,J23]>0)&([G30,H30,I30,J30]>0),[G22,H22,I22,J22]>0,true))|(%JB%)|(XXB->E11="3")'  || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！'   || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000232'
               || v_split;
           v_flag :=1;
         end if;
       end if;
       v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+23).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+30).col05,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col05,0);
       if (v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(([G23,H23,I23,J23]>0)&([G30,H30,I30,J30]>0),[G22,H22,I22,J22]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000232'
               || v_split;
           v_flag :=1;
         end if;
       end if;
       v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+23).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+30).col06,0);
     v_temcwxx3 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+22).col06,0);
       if (v_temcwxx1 > 0 and v_temcwxx2 > 0 and v_temcwxx3 <= 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(([G23,H23,I23,J23]>0)&([G30,H30,I30,J30]>0),[G22,H22,I22,J22]>0,true))|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】期初与期末数差异过大，请核实负债合计数据填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000232'
               || v_split;
           v_flag :=1;
         end if;
       end if;

   end if;

end if;

/***
18.(if(([G32:J32]<>0)&([G32:J32]<>null),([G32:J32]>=[G33:J33]+[G35:J35]+[G34:J34]+[G36:J36]-0.05),true)|(%JB%))|(XXB->E11="3")
【国】【地】所有者权益(股东权益)合计大于等于其中项之和！如有特殊情况，请填写审核说明！
SH00000236 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col03,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+33).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+34).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+35).col03,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+36).col03,0);
       if (v_temcwxx1 > 0 and v_temcwxx1 is not null and v_temcwxx1 < v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(([G32:J32]<>0)&([G32:J32]<>null),([G32:J32]>=[G33:J33]+[G35:J35]+[G34:J34]+[G36:J36]-0.05),true)|(%JB%))|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】所有者权益(股东权益)合计大于等于其中项之和！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000236'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col04,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+33).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+34).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+35).col04,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+36).col04,0);
       if (v_temcwxx1 > 0 and v_temcwxx1 is not null and v_temcwxx1 < v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(([G32:J32]<>0)&([G32:J32]<>null),([G32:J32]>=[G33:J33]+[G35:J35]+[G34:J34]+[G36:J36]-0.05),true)|(%JB%))|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】所有者权益(股东权益)合计大于等于其中项之和！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000236'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col05,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+33).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+34).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+35).col05,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+36).col05,0);
       if (v_temcwxx1 > 0 and v_temcwxx1 is not null and v_temcwxx1 < v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(([G32:J32]<>0)&([G32:J32]<>null),([G32:J32]>=[G33:J33]+[G35:J35]+[G34:J34]+[G36:J36]-0.05),true)|(%JB%))|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】所有者权益(股东权益)合计大于等于其中项之和！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000236'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col06,0);
     v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+33).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+34).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+35).col06,0)
                 + nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+36).col06,0);
       if (v_temcwxx1 > 0 and v_temcwxx1 is not null and v_temcwxx1 < v_temcwxx2 - 500 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS ||  '(if(([G32:J32]<>0)&([G32:J32]<>null),([G32:J32]>=[G33:J33]+[G35:J35]+[G34:J34]+[G36:J36]-0.05),true)|(%JB%))|(XXB->E11="3")'    || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】所有者权益(股东权益)合计大于等于其中项之和！如有特殊情况，请填写审核说明！'    || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000236'
               || v_split;
           v_flag :=1;
         end if;
       end if;

   end if;

end if;


/***
19.([G32:J32]<>0)|(%JB%)|(XXB->E11="3")
【国】【地】股东权益合计不应该为0，请核实资产总计与负债合计是否填错或漏填。！如有特殊情况，请填写审核说明！
SH00000237 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col03,0);
       if (v_temcwxx1 = 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G32:J32]<>0)|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】股东权益合计不应该为0，请核实资产总计与负债合计是否填错或漏填。！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000237'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col04,0);
       if (v_temcwxx1 = 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G32:J32]<>0)|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM ||  '【国】【地】股东权益合计不应该为0，请核实资产总计与负债合计是否填错或漏填。！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000237'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col05,0);
       if (v_temcwxx1 = 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G32:J32]<>0)|(%JB%)|(XXB->E11="3")'  || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】股东权益合计不应该为0，请核实资产总计与负债合计是否填错或漏填。！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000237'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+32).col06,0);
       if (v_temcwxx1 = 0 and v_temqyjbxx <> 3) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '([G32:J32]<>0)|(%JB%)|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM ||  '【国】【地】股东权益合计不应该为0，请核实资产总计与负债合计是否填错或漏填。！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000237'
               || v_split;
           v_flag :=1;
         end if;
       end if;

   end if;

end if;


/****************表内校验表间校验补充开始**************/

/***
(if(t(2)="12",[G3:G36]=[J3:J36],true))|(XXB->E11="3")
【国】【地】财务表资产负债有关指标本年年初数与上年年末数据不相符，请核实！修改请从一季度期初数开始修改，并计算各季度财务表。如有特殊情况请填写审核说明！
SH00000217 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1:=0;
   v_temcwxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
      for i in 3 .. 36 loop
        v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+i).col03,0);
        v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+i).col06,0);
       if v_temqyjbxx <> 3 and substr(i_sssq_q,6 ,2) = '12' and v_temcwxx1 <> v_temcwxx2 then
           --o_retSHGS := o_retSHGS || '(if(t(2)="12",[G3:G36]=[J3:J36],true))|(XXB->E11="3")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】财务表资产负债有关指标本年年初数与上年年末数据不相符，请核实！修改请从一季度期初数开始修改，并计算各季度财务表。如有特殊情况请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000217'
               || v_split;
               exit;
       end if;
     end loop;

   end if;

end if;


/***
if(
    ((t(2)="03")&(C20>10000))|
    ((t(2)="06")&(C20>15000))|
    ((t(2)="09")&(C20>25000))|
    ((t(2)="12")&(C20>50000)),

C20<=C3*0.5,
true
)
【国】【地】利润总额偏大，请核实。如有特殊情况，请填写审核说明
SH00000212 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col01,0);
   v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col01,0);
   
   if (substr(i_sssq_q,6 ,2) = '03' and v_temcwxx2 > 10000) or
      (substr(i_sssq_q,6 ,2) = '06' and v_temcwxx2 > 15000) or
      (substr(i_sssq_q,6 ,2) = '09' and v_temcwxx2 > 25000) or
      (substr(i_sssq_q,6 ,2) = '12' and v_temcwxx2 > 50000) then
      
      if v_temcwxx2 > v_temcwxx1 * 0.5 then
        --o_retSHGS := o_retSHGS || 'if(((t(2)="03")&(C20>10000))|((t(2)="06")&(C20>15000))|((t(2)="09")&(C20>25000))|((t(2)="12")&(C20>50000)),C20<=C3*0.5,true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】利润总额偏大，请核实。如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000212'
               || v_split;
       end if;
    end if;

end if;



/***
if(
    ((t(2)="03")&(D20>10000))|
    ((t(2)="06")&(D20>15000))|
    ((t(2)="09")&(D20>25000))|
    ((t(2)="12")&(D20>50000)),


D20<=D3*0.5,
true
)
【国】【地】利润总额偏大，请核实。如有特殊情况，请填写审核说明
SH00000213 true
**/
if v_sb_zdsy_cwxx.count>0 then
   v_temcwxx1 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col02,0);
   v_temcwxx2 := nvl(v_sb_zdsy_cwxx(v_cwxx_baseROW+20).col02,0);
   
   if (substr(i_sssq_q,6 ,2) = '03' and v_temcwxx2 > 10000) or
      (substr(i_sssq_q,6 ,2) = '06' and v_temcwxx2 > 15000) or
      (substr(i_sssq_q,6 ,2) = '09' and v_temcwxx2 > 25000) or
      (substr(i_sssq_q,6 ,2) = '12' and v_temcwxx2 > 50000) then
      
      if v_temcwxx2 > v_temcwxx1 * 0.5 then
        --o_retSHGS := o_retSHGS || 'if(((t(2)="03")&(D20>10000))|((t(2)="06")&(D20>15000))|((t(2)="09")&(D20>25000))|((t(2)="12")&(D20>50000)),D20<=D3*0.5,true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】利润总额偏大，请核实。如有特殊情况，请填写审核说明'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000213'
               || v_split;
       end if;
    end if;

end if;



/****************表内校验表间校验补充结束**************/





  END P_SB_BJJY_CWBB;



  ---------------------------------------------------------------------------------------------------
  --=================================================================================================
  ---------------------------以下方法为：税收表---------------------------------------------
  --=================================================================================================
  ---------------------------------------------------------------------------------------------------
--企业税收报表校验
  procedure P_SB_BJJY_QYSSXX(
      i_nsrsbh   IN       VARCHAR2,--纳税人识别号
   i_sssq_q   IN       VARCHAR2,--所属时期起
   i_sssq_z   IN       VARCHAR2,--所属时期止
   o_retSHGS     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHSM     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHBJ     OUT      CLOB  --返回检查结果，如果有空字符或者字符串长度为0
)
is

   type t_sb_zdsy_cwxx_rowtype is table of sb_zdsy_cwxx%rowtype index by binary_integer; --定义财务信息表类型
   type t_sb_zdsy_qyssxx_rowtype is table of sb_zdsy_qyssxx%rowtype index by binary_integer; --定义企业税收信息表类型
   type t_sb_zdsy_cpssb_rowtype is table of sb_zdsy_cpssb%rowtype index by binary_integer; --定义主要产品税收表类型
   type t_sb_zdsy_qyjbxx_rowtype is table of sb_zdsy_qyjbxx%rowtype index by binary_integer; --定义基本信息表类型
   type t_sb_zdsy_jqdcwj_rowtype is table of sb_zdsy_jqdcwj%rowtype index by binary_integer; --定义调查问卷表类型

--增加变量
   v_sb_zdsy_qyssxx_sq    t_sb_zdsy_qyssxx_rowtype;--定义税收信息表变量(上期数据)

   v_sb_zdsy_cwxx t_sb_zdsy_cwxx_rowtype;--定义财务信息表变量
   v_sb_zdsy_qyssxx t_sb_zdsy_qyssxx_rowtype;--定义企业税收信息表变量
   v_sb_zdsy_cpssb t_sb_zdsy_cpssb_rowtype;--定义主要产品税收表变量
   v_sb_zdsy_qyjbxx t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量
   v_sb_zdsy_jqdcwj t_sb_zdsy_jqdcwj_rowtype;--定义调查问卷表变量
   
   type t_qyssxx_arr is table of number;
   --G79+G83+G92+G95+G108+G110+G112+G129+G131+G135+G137+
   --G140+G142+G144+G146+G147+G149+G150+G151+G152+G153+
   --G154+G155+G156+G157
   v_qyssxx_arr  t_qyssxx_arr := t_qyssxx_arr(79,83,92,95,108,110,112,129,131,135,137,
                                                              140,142,144,146,147,149,150,151,152,153,
                                                              154,155,156,157);


   v_wcfw INT DEFAULT 0;         --误差范围为1元, 2017.01.07不允许误差，设定误差为0
   v_temqyjbxx_char        varchar2(100);--企业基本信息字符串类型变量
   v_temqyjbxx_char2      varchar2(100);--企业基本信息字符串类型变量
   v_temqyjbxx_char3      varchar2(100);--企业基本信息字符串类型变量
   v_temcwxx              NUMBER (16, 2);--财务信息表变量
   v_temcwxx1              NUMBER (16, 2);--财务信息表变量
   v_temcwxx2              NUMBER (16, 2);--财务信息表变量
   v_temqyssxx            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx1            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx2            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx3            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx4            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx5            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx6            NUMBER (16, 2);--企业税收信息表变量
   v_temcpssb             NUMBER (16, 2);--主要产品税收表变量
   v_temjqdcwj            NUMBER (16, 2);--调查问卷表变量
   v_temqyjbxx            NUMBER (16, 2);--基本信息表变量
   v_temqyjbxx1             varchar2 (100);--基本信息表变量
   v_temqyjbxx_str             varchar2 (100);--基本信息表变量
   v_count              NUMBER;
   v_qyjbxx_baseROW           NUMBER;
   v_cwxx_baseROW           NUMBER;
   v_qyssxx_baseROW        NUMBER;
   v_split                   varchar2(10) := ',';
   v_flag varchar2(1) := 0;--用于标记是否保存过该公式
   v_gsflag varchar2(1) := 0;--用于公式计算中的标记
BEGIN

v_qyjbxx_baseROW:=0;
v_qyssxx_baseROW:=-2;
v_cwxx_baseROW:=0;

   select * bulk collect into v_sb_zdsy_cwxx --给财务信息表变量赋值
     from sb_zdsy_cwxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyssxx --给企业税收信息表变量赋值
     from sb_zdsy_qyssxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_cpssb --给主要产品税收表变量赋值
     from sb_zdsy_cpssb t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyjbxx --给基本信息表变量赋值
     from sb_zdsy_qyjbxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_jqdcwj --给调查问卷表变量赋值
     from sb_zdsy_jqdcwj t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;



/****
************************************************************************************
********************************税收信息校验B1表*************************************
********************************童彬彬2017年1月17日14:15:12*************************************
************************************************************************************
****/
--(if((XXB->E13<>"0")&(XXB->E13<>null),[D60,F60]<=[D58,F58],true))
--1.【国】免抵退货物应退税额<=上期留抵税额!如有特殊情况，请填写审核说明！SH00000095  TRUE
/*if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+13).col01,0);
   end if;

   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+60).col01,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+58).col01,0);
         if (v_temqyssxx>v_temqyssxx2) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if((XXB->E13<>"0")&(XXB->E13<>null),[D60,F60]<=[D58,F58],true))' || v_split;
             --o_retSHSM := o_retSHSM || '【国】免抵退货物应退税额<=上期留抵税额!如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000095'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+60).col03,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+58).col03,0);
         if (v_temqyssxx>v_temqyssxx2) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||'(if((XXB->E13<>"0")&(XXB->E13<>null),[D60,F60]<=[D58,F58],true))' || v_split;
             --o_retSHSM := o_retSHSM ||'【国】免抵退货物应退税额<=上期留抵税额!如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000095'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
   end if;

end if;*/

--([D77,F77]>=0)|(left(XXB->E4,2)="16")|(left(XXB->E4,2)="25")|(left(XXB->E4,2)="44")|([D76,F76]<0)
--2.【国】应纳税额合计应大于等于0，除去烟草、石油、电力！如有特殊情况，请填写审核说明！SH00000107  TRUE
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_temqyjbxx1:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx1 := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01,0);
         v_temqyjbxx1 := substr(v_temqyjbxx1,1,2);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+77).col01,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+76).col01,0);
         if (v_temqyssxx<0) and v_temqyjbxx <>'16' and v_temqyjbxx<>'25' and v_temqyjbxx <> '44' and v_temqyssxx2>=0 then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([D77,F77]>=0)|(left(XXB->E4,2)="16")|(left(XXB->E4,2)="25")|(left(XXB->E4,2)="44")|([D76,F76]<0)' || v_split;
             --o_retSHSM := o_retSHSM ||  '【国】应纳税额合计应大于等于0，除去烟草、石油、电力！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000107'
                 || v_split;
             v_flag :=1;
           end if;
         end if;
     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+77).col03,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+76).col03,0);
         if (v_temqyssxx<0) and v_temqyjbxx <>'16' and v_temqyjbxx<>'25' and v_temqyjbxx <> '44' and v_temqyssxx2>=0 then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '([D77,F77]>=0)|(left(XXB->E4,2)="16")|(left(XXB->E4,2)="25")|(left(XXB->E4,2)="44")|([D76,F76]<0)'  || v_split;
             --o_retSHSM := o_retSHSM ||'【国】应纳税额合计应大于等于0，除去烟草、石油、电力！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000107'
                 || v_split;
             v_flag :=1;
           end if;
         end if;

end if;


--(((if(XXB->E4="1620",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),if(XXB->E4="2511",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2)))))|(([D85,F85]=0)&([D84,F84]=0))))
/*
((
(
    if(XXB->E4="1620",   ---烟草制造
       ([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),
         if(XXB->E4="2511",   --石油
              ([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),
                ([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2))
          )
     )
)
|(([D85,F85]=0)&([D84,F84]=0))
))
*/
--3.【国】请核实消费税应纳税额和应征消费税的销售额填写是否正确！如有特殊情况，请填写审核说明！SH00000117 TRUE
/*if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01,0);
   end if;

    v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+85).col01,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+84).col01,0);
     if(v_temqyssxx = 0 or v_temqyssxx2 = 0) then
       if v_temqyjbxx = '1620' then
           if v_temqyssxx<v_temqyssxx2*0.01 or (v_temqyssxx>v_temqyssxx2*0.65) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS ||  '(((if(XXB->E4="1620",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),if(XXB->E4="2511",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2)))))|(([D85,F85]=0)&([D84,F84]=0))))'   || v_split;
               --o_retSHSM := o_retSHSM ||  '【国】请核实消费税应纳税额和应征消费税的销售额填写是否正确！如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000117'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
        else
           if v_temqyjbxx = '2511' then
             if (v_temqyssxx<round(v_temqyssxx2*0.01,2)) or (v_temqyssxx>round(v_temqyssxx2*0.45,2)) then
               if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(((if(XXB->E4="1620",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),if(XXB->E4="2511",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2)))))|(([D85,F85]=0)&([D84,F84]=0))))' || v_split;
               --o_retSHSM := o_retSHSM ||  '【国】请核实消费税应纳税额和应征消费税的销售额填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000117'
                   || v_split;
               v_flag :=1;
             end if;
             end if;
           else
             if (v_temqyssxx>=round(v_temqyssxx2*0.01,2)) or (v_temqyssxx<=round(v_temqyssxx2*0.30,2)) then
               if v_flag<>1 then
               --o_retSHGS := o_retSHGS ||  '(((if(XXB->E4="1620",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),if(XXB->E4="2511",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2)))))|(([D85,F85]=0)&([D84,F84]=0))))'    || v_split;
               --o_retSHSM := o_retSHSM ||  '【国】请核实消费税应纳税额和应征消费税的销售额填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000117'
                   || v_split;
               v_flag :=1;
               end if;
             end if;
           end if;
         end if;
     end if;


     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+85).col03,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+84).col03,0);
     if(v_temqyssxx = 0 or v_temqyssxx2 = 0) then
       if v_temqyjbxx = '1620' then
           if v_temqyssxx<v_temqyssxx2*0.01 or (v_temqyssxx>v_temqyssxx2*0.65) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(((if(XXB->E4="1620",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),if(XXB->E4="2511",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2)))))|(([D85,F85]=0)&([D84,F84]=0))))'  || v_split;
               --o_retSHSM := o_retSHSM || '【国】请核实消费税应纳税额和应征消费税的销售额填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000117'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
        else
           if v_temqyjbxx = '2511' then
             if (v_temqyssxx<round(v_temqyssxx2*0.01,2)) or (v_temqyssxx>round(v_temqyssxx2*0.45,2)) then
               if v_flag<>1 then
               --o_retSHGS := o_retSHGS ||  '(((if(XXB->E4="1620",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),if(XXB->E4="2511",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2)))))|(([D85,F85]=0)&([D84,F84]=0))))'  || v_split;
               --o_retSHSM := o_retSHSM || '【国】请核实消费税应纳税额和应征消费税的销售额填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000117'
                   || v_split;
               v_flag :=1;
             end if;
             end if;
           else
             if (v_temqyssxx>=round(v_temqyssxx2*0.01,2)) or (v_temqyssxx<=round(v_temqyssxx2*0.30,2)) then
               if v_flag<>1 then
               --o_retSHGS := o_retSHGS || '(((if(XXB->E4="1620",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.65,2)),if(XXB->E4="2511",([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.45,2)),([D85,F85]>=round([D84,F84]*0.01,2))&([D85,F85]<=round([D84,F84]*0.30,2)))))|(([D85,F85]=0)&([D84,F84]=0))))'  || v_split;
               --o_retSHSM := o_retSHSM || '【国】请核实消费税应纳税额和应征消费税的销售额填写是否正确！如有特殊情况，请填写审核说明！'  || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000117'
                   || v_split;
               v_flag :=1;
               end if;
             end if;
           end if;
         end if;
     end if;


end if;*/


--(if(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(D104<>0),(D104<D103*0.26),true))&(if(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(F104<>0),(F104<F103*0.26),true))
/*
(
    if(
    ((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(D104<>0),
    (D104<D103*0.26),
    true
    )
)
&
(
    if(
    ((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(F104<>0),
    (F104<F103*0.26),
    true
    )
)
*/
--4.【国】【地】据实预缴的独立预缴企业所得税的纳税人、按比例预缴企业所得税的汇总成员企业、汇总下级公司预缴企业所得税的总公司、总分机构中的总机构纳税人，企业应纳所得税额（104行）与实际利润比值大于法定税率25%,请核实 SH00000129 TRUE
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01,0);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+104).col01,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+103).col01,0);
         if v_temqyssxx = '0' or (v_temqyjbxx <>'11' and v_temqyjbxx<>'12' or v_temqyjbxx <> '13' or v_temqyjbxx<>'15') then
           if(v_temqyssxx >= v_temqyssxx2*0.26) then
              if v_flag<>1 then
                 --o_retSHGS := o_retSHGS ||  '(if(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(D104<>0),(D104<D103*0.26),true))&(if(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(F104<>0),(F104<F103*0.26),true))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】【地】据实预缴的独立预缴企业所得税的纳税人、按比例预缴企业所得税的汇总成员企业、汇总下级公司预缴企业所得税的总公司、总分机构中的总机构纳税人，企业应纳所得税额（104行）与实际利润比值大于法定税率25%,请核实'   || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000129'
                     || v_split;
                 v_flag :=1;
               end if;
           end if;
         end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+104).col03,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+103).col03,0);
         if v_temqyssxx = '0' or (v_temqyjbxx <>'11' and v_temqyjbxx<>'12' or v_temqyjbxx <> '13' or v_temqyjbxx<>'15') then
           if(v_temqyssxx >= v_temqyssxx2*0.26) then
              if v_flag<>1 then
                 --o_retSHGS := o_retSHGS ||  '(if(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(D104<>0),(D104<D103*0.26),true))&(if(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(F104<>0),(F104<F103*0.26),true))'  || v_split;
                 --o_retSHSM := o_retSHSM || '【国】【地】据实预缴的独立预缴企业所得税的纳税人、按比例预缴企业所得税的汇总成员企业、汇总下级公司预缴企业所得税的总公司、总分机构中的总机构纳税人，企业应纳所得税额（104行）与实际利润比值大于法定税率25%,请核实'   || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000129'
                     || v_split;
                 v_flag :=1;
               end if;
           end if;
         end if;
end if;


--((IF(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(E104<>0),(E104<E103*0.26)&(E104>=E103*0.1),true))&(IF(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(G104<>0),(G104<G103*0.26)&(G104>=G103*0.1),true)))
/*
(
(
IF(
((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(E104<>0),
(E104<E103*0.26)&(E104>=E103*0.1),
true
)
)
&
(IF(
((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(G104<>0),
(G104<G103*0.26)&(G104>=G103*0.1),
true
))
)

*/
--5.【国】【地】应纳所得税额应在实际利润额的0.1与0.3之间！如有特殊情况，请填写审核说明！
--SH00000130  TRUE
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01,0);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+104).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+103).col02,0);
         if (v_temqyjbxx <> '11' and v_temqyjbxx <>'12' and v_temqyjbxx<>'13' and v_temqyjbxx <> '15') or v_temqyssxx=0 then
            if (v_temqyssxx>=v_temqyssxx2*0.26) or (v_temqyssxx<v_temqyssxx2*0.1) then
                if v_flag<>1 then
                 --o_retSHGS := o_retSHGS ||'((IF(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(E104<>0),(E104<E103*0.26)&(E104>=E103*0.1),true))&(IF(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(G104<>0),(G104<G103*0.26)&(G104>=G103*0.1),true)))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】【地】应纳所得税额应在实际利润额的0.1与0.3之间！如有特殊情况，请填写审核说明！' || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000130'
                     || v_split;
                 v_flag :=1;
               end if;
            end if;
         end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+104).col04,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+103).col04,0);
         if (v_temqyjbxx <> '11' and v_temqyjbxx <>'12' and v_temqyjbxx<>'13' and v_temqyjbxx <> '15') or v_temqyssxx=0 then
            if (v_temqyssxx>=v_temqyssxx2*0.26) or (v_temqyssxx<v_temqyssxx2*0.1) then
                if v_flag<>1 then
                 --o_retSHGS := o_retSHGS || '((IF(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(E104<>0),(E104<E103*0.26)&(E104>=E103*0.1),true))&(IF(((XXB->E17="11")|(XXB->E17="12")|(XXB->E17="13")|(XXB->E17="15"))&(G104<>0),(G104<G103*0.26)&(G104>=G103*0.1),true)))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】【地】应纳所得税额应在实际利润额的0.1与0.3之间！如有特殊情况，请填写审核说明！' || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000130'
                     || v_split;
                 v_flag :=1;
               end if;
            end if;
         end if;

end if;

--(if((XXB->E18=null)|(XXB->E18="040100"),(E105=0)|(E105=null),true))
/*
(
if(
    (XXB->E18=null)|(XXB->E18="040100"),
    (E105=0)|(E105=null),
    true
  )
)
*/
--6.【国】【地】信息表企业所得税优惠政策未填写或者无企业所得税优惠政策，税收表减免所得税额应为空！如有特殊情况，请填写审核说明！
--SH00000133 TRUE
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+18).col01,0);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col02,0);
         if v_temqyjbxx is null or v_temqyjbxx = '040100' then
           if(v_temqyssxx <>0 and v_temqyssxx is not null) then
              if v_flag<>1 then
                 --o_retSHGS := o_retSHGS || '(if((XXB->E18=null)|(XXB->E18="040100"),(E105=0)|(E105=null),true))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】【地】信息表企业所得税优惠政策未填写或者无企业所得税优惠政策，税收表减免所得税额应为空！如有特殊情况，请填写审核说明！'  || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000133'
                     || v_split;
                 v_flag :=1;
               end if;
           end if;
         end if;
end if;


/*===================================== 张彬 =====================================*/
--7.【国】【地】信息表企业所得税缴纳方式不为据实预缴或核定征收的，税收表减免所得税额应为空！如有特殊情况，请填写审核说明！
--SH00000134
--TRUE
--(if((left(XXB->E17,1)<>"3")&(left(XXB->E17,1)<>"1"),([E105,G105]=0)|([E105,G105]=null),true))
/*
(
if(
(left(XXB->E17,1)<>"3")&(left(XXB->E17,1)<>"1"),
([E105,G105]=0)|([E105,G105]=null),
true
)
)
*/

if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01,0);
         v_temqyjbxx := substr(v_temqyjbxx,1,1);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col04,0);
         if v_temqyjbxx<> '3' and v_temqyjbxx<> '1' then
           if (v_temqyssxx <> 0 and v_temqyssxx is not null) or (v_temqyssxx2 <> 0 and v_temqyssxx2 is not null) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if((left(XXB->E17,1)<>"3")&(left(XXB->E17,1)<>"1"),([E105,G105]=0)|([E105,G105]=null),true))' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】信息表企业所得税缴纳方式不为据实预缴或核定征收的，税收表减免所得税额应为空！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000134'
                 || v_split;
             v_flag :=1;
           end if;
           end if;
         end if;
end if;

--8.【国】【地】总机构纳税人企业所得税应纳税调整额应小于等于0！如有特殊情况，请填写审核说明！
--SH00000135
--TRUE
--((if((XXB->E17="15")|(XXB->E17="25")|(XXB->E17="41"),[E106,G106]<=0,true))|(%JB%))
/*
(
(
if(
(XXB->E17="15")|(XXB->E17="25")|(XXB->E17="41"),
[E106,G106]<=0,
true)
)|(%JB%)
)
*/

if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01,0);
         v_temqyjbxx := substr(v_temqyjbxx,1,1);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col04,0);
         if v_temqyjbxx<> '3' and v_temqyjbxx<> '1' then
           if (v_temqyssxx <> 0 and v_temqyssxx is not null) or (v_temqyssxx2 <> 0 and v_temqyssxx2 is not null) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS ||  '((if((XXB->E17="15")|(XXB->E17="25")|(XXB->E17="41"),[E106,G106]<=0,true))|(%JB%))'  || v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】总机构纳税人企业所得税应纳税调整额应小于等于0！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000135'
                 || v_split;
             v_flag :=1;
           end if;
           end if;
         end if;
end if;

--9.【国】【地】分支机构纳税人企业所得税应纳税调整额应大于等于0！如有特殊情况，请填写审核说明！
--SH00000136
--TRUE
--((if((XXB->E17="16")|(XXB->E17="26")|(XXB->E17="42"),[E106,G106]>=0,true))|(%JB%))
/*
(
(
if(
(XXB->E17="15")|(XXB->E17="25")|(XXB->E17="41"),
[E106,G106]<=0,
true)
)|(%JB%)
)
*/

if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01,0);
         v_temqyjbxx := substr(v_temqyjbxx,1,1);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col04,0);
         if v_temqyjbxx<> '3' and v_temqyjbxx<> '1' then
           if (v_temqyssxx <> 0 and v_temqyssxx is not null) or (v_temqyssxx2 <> 0 and v_temqyssxx2 is not null) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '((if((XXB->E17="16")|(XXB->E17="26")|(XXB->E17="42"),[E106,G106]>=0,true))|(%JB%))' || v_split;
             --o_retSHSM := o_retSHSM ||'【国】【地】分支机构纳税人企业所得税应纳税调整额应大于等于0！如有特殊情况，请填写审核说明！'  || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000136'
                 || v_split;
             v_flag :=1;
           end if;
           end if;
         end if;
end if;

--10.【国】【地】上报上级公司预缴企业所得税的纳税人，企业所得税汇算清缴实际补(退)税额不应有数!如有特殊情况，请填写审核说明！
--SH00000140
--TRUE
--(if((XXB->E17="14")|(XXB->E17="24"),([E110,G110]=0)|([E110,G110]=null),true))
/*
(
if((XXB->E17="14")|(XXB->E17="24"),
([E110,G110]=0)|([E110,G110]=null),
true)
)
*/

if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01,0);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+110).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+110).col04,0);
         if v_temqyjbxx = '14' or v_temqyjbxx = '24' then
           if (v_temqyssxx <> 0 and v_temqyssxx is not null) or (v_temqyssxx2 <> 0 and v_temqyssxx2 is not null) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if((XXB->E17="14")|(XXB->E17="24"),([E110,G110]=0)|([E110,G110]=null),true))' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】上报上级公司预缴企业所得税的纳税人，企业所得税汇算清缴实际补(退)税额不应有数!如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000140'
                 || v_split;
             v_flag :=1;
           end if;
           end if;
         end if;
end if;

/***
11.if(XXB->E20="0",([D96:D111]=0)&([F96:F111]=0),true)
【国】【地】企业所得税申报周期选择“不申报”，企业所得税除查补所得税外，其他指标应无数，如有特殊情况，请填写审核说明
SH00000143 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+20).col01,999);
   end if;



   if v_temqyjbxx <>999 and v_temqyjbxx is not null then
      for i in 96..111 loop
         v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col01,0);
         v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col03,0);
           if (v_temqyjbxx = '0' and (v_temqyssxx1 <> 0 or v_temqyssxx2 <> 0)) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS ||  'if(XXB->E20="0",([D96:D111]=0)&([F96:F111]=0),true)'   || v_split;
               --o_retSHSM := o_retSHSM || '【国】【地】不申报企业所得税的纳税人，企业所得税除查补所得税外，其他指标应无数，如有特殊情况，请填写审核说明！'  || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000143'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
      end loop;

   end if;
end if;



--14.【地】只有个人独资、个人合伙和个体经营可填写此项，其他企业在157行代扣代缴个人所得税中填写！如有特殊情况，请填写审核说明！
--SH00000161
--TRUE
--(if((left(XXB->E6,1)<>"4"),([D147,F147]=0)|([D147,F147]=null),true))
/*
(
if(
(left(XXB->E6,1)<>"4"),
([D147,F147]=0)|([D147,F147]=null),
true)
)
*/

if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_str := v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+6).col01;
         v_temqyjbxx_str := substr(v_temqyjbxx,1,1);
   end if;

     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+147).col01,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+147).col03,0);
         if v_temqyjbxx <> '4' then
           if (v_temqyssxx <> 0 and v_temqyssxx is not null) or (v_temqyssxx2 <> 0 and v_temqyssxx2 is not null) then
           if v_flag<>1 then
             --o_retSHGS := o_retSHGS || '(if((left(XXB->E6,1)<>"4"),([D147,F147]=0)|([D147,F147]=null),true))' || v_split;
             --o_retSHSM := o_retSHSM || '【地】只有个人独资、个人合伙和个体经营可填写此项，其他企业在157行代扣代缴个人所得税中填写！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000161'
                 || v_split;
             v_flag :=1;
           end if;
           end if;
         end if;
end if;

/***
15.(if(E79+E92+E131>10,(E160>0)&(E161>0),true))
【国】【地】请核实是否填报教育费附加和地方教育费附加！如有特殊情况，请填写审核说明！
SH00000168 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1:=0;
   v_temqyssxx2:=0;
   v_temqyssxx3:=0;
   v_temqyssxx4:=0;
   v_temqyssxx5:=0;
   v_temqyjbxx:=0;
   v_flag :=0;


   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+79).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col02,0);
     v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+131).col02,0);
     v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+160).col02,0);
     v_temqyssxx5 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+161).col02,0);
       if ((v_temqyssxx1 + v_temqyssxx2 + v_temqyssxx3 > 10) and (v_temqyssxx4 <= 0 or v_temqyssxx5 <= 0)) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS ||  'if(E79+E92+E131>10,(E160>0)&(E161>0),true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】请核实是否填报教育费附加和地方教育费附加！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000168'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;
end if;

/***
16.if(G79+G92+G131>10,(G160>0)&(G161>0),true)
【国】【地】请核实是否填报教育费附加和地方教育费附加！如有特殊情况，请填写审核说明！
SH00000169 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1:=0;
   v_temqyssxx2:=0;
   v_temqyssxx3:=0;
   v_temqyssxx4:=0;
   v_temqyssxx5:=0;
   v_temqyjbxx:=0;
   v_flag :=0;


   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+79).col04,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col04,0);
     v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+131).col04,0);
     v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+160).col04,0);
     v_temqyssxx5 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+161).col04,0);
       if ((v_temqyssxx1 + v_temqyssxx2 + v_temqyssxx3 > 10) and (v_temqyssxx4 <= 0 or v_temqyssxx5 <= 0)) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || 'if(G79+G92+G131>10,(G160>0)&(G161>0),true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】请核实是否填报教育费附加和地方教育费附加！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000169'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;
end if;








    /***
  32.if((XXB->E12<>"00"),(sum(B1->D3:B1->D83)<>0),true)
  【国】增值税纳税人必须填写增值税相关指标，如有特殊情况，请填写审核说明！
  SH00000198 true
  **/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyjbxx:=0;
   v_flag :=0;

   if v_sb_zdsy_qyjbxx.count>0 then
     v_temqyjbxx1 := v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+12).col01;
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+12).col01,0);
   end if;


   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     for i in 3..83 loop
       v_temqyssxx := v_temqyssxx + nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col01,0);
     end loop;

       if (v_temqyjbxx <> '00' and v_temqyssxx = 0) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS ||   'if((XXB->E12<>"00"),(sum(B1->D3:B1->D83)<>0),true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】增值税纳税人必须填写增值税相关指标，如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000198'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;
end if;

       --31
       --if((XXB->E15<>"0"),(sum(D84:D95)<>0)&(sum(F84:F95)<>0),true)
        /*
           if(
                (XXB->E15<>"0"),
                (sum(D84:D95)<>0)&(sum(F84:F95)<>0),
                true
            )
        */
        --【国】消费税纳税人必须填写消费税相关指标，如有特殊情况，请填写审核说明！
        --SH00000199
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyjbxx_char := '';
   v_temqyssxx :=0;
   v_temqyssxx2 :=0;
   v_flag :=0;

   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_char := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+15).col01,'');
   end if;


   if v_temqyjbxx_char != '' and v_temqyjbxx is not null then
     for i in 84..95 loop
           v_temqyssxx  :=  v_temqyssxx + v_sb_zdsy_qyssxx(i+v_qyssxx_baseROW).col01;
           v_temqyssxx2  :=  v_temqyssxx2 + v_sb_zdsy_qyssxx(i+v_qyssxx_baseROW).col03;
       end loop;
       if v_temqyjbxx_char!='' then
           if v_temqyssxx=0 or v_temqyssxx2=0 then
                 --o_retSHGS := o_retSHGS || 'if((XXB->E15<>"0"),(sum(D84:D95)<>0)&(sum(F84:F95)<>0),true)' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】消费税纳税人必须填写消费税相关指标，如有特殊情况，请填写审核说明！'  || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000199'
                     || v_split;
           end if;
       end if;


   end if;
end if;


  --23  --if((E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+E154+E155+E156+E157>20000)&((left(XXB->E4,2)<>"70")|(left(XXB->E4,2)<>"67")),((E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+E154+E155+E156+E157)/(G79+G83+G92+G95+G108+G110+G112+G129+G131+G135+G137+G140+G142+G144+G146+G147+G149+G150+G151+G152+G153+G154+G155+G156+G157)>=0.5)&((E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+E154+E155+E156+E157)/(G79+G83+G92+G95+G108+G110+G112+G129+G131+G135+G137+G140+G142+G144+G146+G147+G149+G150+G151+G152+G153+G154+G155+G156+G157)<=2),true)
       /*
            if(
                   =============if第一部分(a>20000 & (b1|b2))=============
                   ( E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+
                     E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+
                     E154+E155+E156+E157>20000)
                          &
                  ((left(XXB->E4,2)<>"70")|(left(XXB->E4,2)<>"67")),
                  =============if第二部分（a/b>=0.5 & c/d<=2）=============
                 (
                    (E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+
                     E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+
                     E154+E155+E156+E157)
                         /
                    (G79+G83+G92+G95+G108+G110+G112+G129+G131+G135+G137+
                     G140+G142+G144+G146+G147+G149+G150+G151+G152+G153+
                     G154+G155+G156+G157)
                       >=0.5
                  )
                       &
                 (
                     (E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+
                      E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+
                      E154+E155+E156+E157)
                        /
                    (G79+G83+G92+G95+G108+G110+G112+G129+G131+G135+G137+
                     G140+G142+G144+G146+G147+G149+G150+G151+G152+G153+
                     G154+G155+G156+G157)
                      <=2
                ),
                --if第三部分
               true)
        */
        --【国】【地】本年已缴税收合计累计数与上年已缴税收合计累计数差额不能超过2倍，如有特殊情况，请填写审核说明
        -- SH00000188
 if v_sb_zdsy_qyssxx.count>0 then
   v_temqyjbxx_char := '';
   v_temqyssxx :=0;
   v_temqyssxx2 :=0;
   v_flag :=0;

   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_char := nvl(substr(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01,1,2),'');
   end if;


   if v_temqyjbxx_char != '' and v_temqyjbxx is not null then
     for i in v_qyssxx_arr.first..v_qyssxx_arr.last loop
              v_temqyssxx  :=  v_temqyssxx + v_sb_zdsy_qyssxx(i+v_qyssxx_baseROW).col01;
              v_temqyssxx2  :=  v_temqyssxx2 + v_sb_zdsy_qyssxx(i+v_qyssxx_baseROW).col03;
         end loop;
         if v_temqyssxx>20000*10000 and (v_temqyjbxx_char!='70' or v_temqyjbxx_char!='67') then
              if v_temqyssxx/v_temqyssxx2 <0.5 or v_temqyssxx/v_temqyssxx2 >2 then
                   --o_retSHGS := o_retSHGS ||  'if((E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+E154+E155+E156+E157>20000)&((left(XXB->E4,2)<>"70")|(left(XXB->E4,2)<>"67")),((E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+E154+E155+E156+E157)/(G79+G83+G92+G95+G108+G110+G112+G129+G131+G135+G137+G140+G142+G144+G146+G147+G149+G150+G151+G152+G153+G154+G155+G156+G157)>=0.5)&((E79+E83+E92+E95+E108+E110+E112+E129+E131+E135+E137+E140+E142+E144+E146+E147+E149+E150+E151+E152+E153+E154+E155+E156+E157)/(G79+G83+G92+G95+G108+G110+G112+G129+G131+G135+G137+G140+G142+G144+G146+G147+G149+G150+G151+G152+G153+G154+G155+G156+G157)<=2),true)'  || v_split;
                 --o_retSHSM := o_retSHSM || '【国】【地】本年已缴税收合计累计数与上年已缴税收合计累计数差额不能超过2倍，如有特殊情况，请填写审核说明' || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000188'
                     || v_split;
              end if;
         end if;


   end if;
end if;


/*=====================================王永强=====================================*/

/***
18.((if(((left(XXB->E6,2)<>"17")&(left(XXB->E6,2)<>"19")&(left(XXB->E6,1)<>"4")&(left(XXB->E6,1)<>"5")),if(E179>10,E163>0,true),true))|(%JB%))

((if(((left(XXB->E6,2)<>"17")&(left(XXB->E6,2)<>"19")&(left(XXB->E6,1)<>"4")&(left(XXB->E6,1)<>"5")),if(E179>10*10000,E163>0,true),true))|(%JB%))

【国】【地】本年累计为职工支付的薪酬(含社保基金)大于10万，已缴社保基金应大于0！如有特殊情况，请填写审核说明！
SH00000171 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_str := nvl(substr(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+6).col01,0,2),0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+179).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+163).col02,0);
       if (v_temqyjbxx <> 17 and v_temqyjbxx <> 19 and substr(v_temqyjbxx,0,1) <> 4 and substr(v_temqyjbxx,0,1) <> 5 and v_temqyssxx > 10*10000 and v_temqyssxx2 <= 0) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS ||  '((if(((left(XXB->E6,2)<>"17")&(left(XXB->E6,2)<>"19")&(left(XXB->E6,1)<>"4")&(left(XXB->E6,1)<>"5")),if(E179>10,E163>0,true),true))|(%JB%))' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】本年累计为职工支付的薪酬(含社保基金)大于10万，已缴社保基金应大于0！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000171'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;
end if;



/***
19.((if(((left(XXB->E6,2)<>"17")&(left(XXB->E6,2)<>"19")&(left(XXB->E6,1)<>"4")&(left(XXB->E6,1)<>"5")),if(G179>10,G163>0,true),true))|(%JB%))

((if(((left(XXB->E6,2)<>"17")&(left(XXB->E6,2)<>"19")&(left(XXB->E6,1)<>"4")&(left(XXB->E6,1)<>"5")),if(G179>10*10000,G163>0,true),true))|(%JB%))

【国】【地】本年累计为职工支付的薪酬(含社保基金)大于10万，已缴社保基金应大于0！如有特殊情况，请填写审核说明！
SH00000172 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_str := nvl(substr(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+6).col01,0,2),0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+179).col04,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+163).col04,0);
       if (v_temqyjbxx <> 17 and v_temqyjbxx <> 19 and substr(v_temqyjbxx,0,1) <> 4 and substr(v_temqyjbxx,0,1) <> 5 and v_temqyssxx > 10*10000 and v_temqyssxx2 <= 0) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '((if(((left(XXB->E6,2)<>"17")&(left(XXB->E6,2)<>"19")&(left(XXB->E6,1)<>"4")&(left(XXB->E6,1)<>"5")),if(G179>10,G163>0,true),true))|(%JB%))'  || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】本年累计为职工支付的薪酬(含社保基金)大于10万，已缴社保基金应大于0！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000172'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;
end if;




/***
20.(if(((left(XXB->E4,2)>="06")&(left(XXB->E4,2)<="50")),E166<>0,true))|(XXB->E4="4420")
【国】工业、建筑业企业请核实是否填报电力消费量！如有特殊情况，请填写审核说明！
SH00000175 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_str := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+166).col02,0);
       if (substr(v_temqyjbxx,0,2) >= '06' and substr(v_temqyjbxx,0,2) <= '50' and v_temqyssxx = 0 and v_temqyjbxx <> '4420') then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(((left(XXB->E4,2)>="06")&(left(XXB->E4,2)<="50")),E166<>0,true))|(XXB->E4="4420")' || v_split;
           --o_retSHSM := o_retSHSM ||'【国】工业、建筑业企业请核实是否填报电力消费量！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000175'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;
end if;



/***
21.(if(((left(XXB->E4,2)>="06")&(left(XXB->E4,2)<="50")),G166<>0,true))|(XXB->E4="4420")
【国】工业、建筑业企业请核实是否填报电力消费量！如有特殊情况，请填写审核说明！
SH00000176 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx:=0;
   v_temqyjbxx:=0;
   v_flag :=0;
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_str := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01,0);
   end if;



   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+166).col04,0);
       if (substr(v_temqyjbxx,0,2) >= '06' and substr(v_temqyjbxx,0,2) <= '50' and v_temqyssxx = 0 and v_temqyjbxx <> '4420') then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || '(if(((left(XXB->E4,2)>="06")&(left(XXB->E4,2)<="50")),G166<>0,true))|(XXB->E4="4420")' || v_split;
           --o_retSHSM := o_retSHSM || '【国】工业、建筑业企业请核实是否填报电力消费量！如有特殊情况，请填写审核说明！'|| v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000176'
               || v_split;
           v_flag :=1;
         end if;
       end if;


   end if;
end if;

/***
if(XXB->E12="13",(([D3:D75]=null)|([D3:D75]=0))&(([F3:F75]=null)|([F3:F75]=0)),true)
【国】分公司属地预缴增值税企业不需要填报增值税核算指标，需要将属地预缴增值税数额用“应纳税调整额”指标调增分公司的应纳数。如有特殊情况，请填写审核说明！
SH00000273 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1:=0;
   v_temqyssxx2:=0;
   v_temqyjbxx:=0;
   v_flag :=0;

   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+12).col01,0);
   end if;


   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     for i in 3..75 loop
         v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col01,0);
         v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col03,0);
           if (v_temqyjbxx = '13' and ((v_temqyssxx1 <> 0 and v_temqyssxx1 is not null) or (v_temqyssxx2 <> 0 and v_temqyssxx2 is not null))) then
             if v_flag<>1 then
               --o_retSHGS := o_retSHGS || 'if(XXB->E12="13",(([D3:D75]=null)|([D3:D75]=0))&(([F3:F75]=null)|([F3:F75]=0)),true)' || v_split;
               --o_retSHSM := o_retSHSM || '【国】分公司属地预缴增值税企业不需要填报增值税核算指标，需要将属地预缴增值税数额用“应纳税调整额”指标调增分公司的应纳数。如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000273'
                   || v_split;
               v_flag :=1;
             end if;
           end if;
      end loop;


   end if;
end if;




/*
          税收表表间上期数据
          说明：
              1. 增加v_sb_zdsy_qyssxx_sq    t_sb_zdsy_qyssxx_rowtype;--定义税收信息表变量(上期数据)
*/
/***
(if(E79+E92+E131>10,if(@-1E134>0,E135>0,true),true))
【国】【地】请核实是否填写已缴城市维护建设税！如有特殊情况，请填写审核说明！
SH00000147 true
**/
/*if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+79).col02,0);
   v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col02,0);
   v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+131).col02,0);
   v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+135).col02,0);

   if (v_temqyssxx1 + v_temqyssxx2 + v_temqyssxx3 > 10) then
     --取出上期数据，暂时从本地库查出
         select t.* bulk collect into v_sb_zdsy_qyssxx_sq from sb_zdsy_qyssxx t
         where t.nsrsbh= i_nsrsbh
         and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
         and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
         order by hc;
         if v_sb_zdsy_qyssxx_sq.count > 0 then --上期有数据
           v_temqyssxx5 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+134).col02,0);
           if v_temqyssxx5 > 0 then
             if v_temqyssxx4 <= 0 then
               --o_retSHGS := o_retSHGS ||'if(E79+E92+E131>10,if(@-1E134>0,E135>0,true),true)'|| v_split;
               --o_retSHSM := o_retSHSM ||'【国】【地】请核实是否填写已缴城市维护建设税！如有特殊情况，请填写审核说明！'|| v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000147'
                   || v_split;
             end if;
           end if;
         end if;
         

   end if;
end if;
*/

/***
(if(G79+G92+G131>10,if(@-1G134>0,G135>0,true),true))
【国】【地】请核实是否填写已缴城市维护建设税！如有特殊情况，请填写审核说明！
SH00000148 true
**/
/*if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+79).col04,0);
   v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col04,0);
   v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+131).col04,0);
   v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+135).col04,0);

   if (v_temqyssxx1 + v_temqyssxx2 + v_temqyssxx3 > 10) then
     --取出上期数据，暂时从本地库查出
         select t.* bulk collect into v_sb_zdsy_qyssxx_sq from sb_zdsy_qyssxx t
         where t.nsrsbh= i_nsrsbh
         and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
         and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
         order by hc;
         if v_sb_zdsy_qyssxx_sq.count > 0 then --上期有数据
           v_temqyssxx5 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+134).col04,0);
           if v_temqyssxx5 > 0 then
             if v_temqyssxx4 <= 0 then
               --o_retSHGS := o_retSHGS ||'if(G79+G92+G131>10,if(@-1G134>0,G135>0,true),true)'|| v_split;
               --o_retSHSM := o_retSHSM ||'【国】【地】请核实是否填写已缴城市维护建设税！如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000148'
                   || v_split;
             end if;
           end if;
         end if;
         

   end if;
end if;*/


/***
(if(E162>0,E162<(E79+E92)*0.06,true))|(XXB->E14<>null)|(t(2)="01")|(t(2)="02")|(left(XXB->E4,2)="89")|(XXB->E4="7240")
(if(E162>0,E162<(E79+E92)*0.06,true))|(XXB->E14<>null)|(t(2)="01")|(t(2)="02")|(left(XXB->E4,2)="89")|(XXB->E4="7251")|(XXB->E4="7259")
【国】【地】已缴文化事业建设费应小于增消营的6%！如有特殊情况，请填写审核说明！
SH00000170 true
**/
if v_sb_zdsy_qyssxx.count>0 then
  v_temqyssxx1 := 0;
  v_temqyssxx2 := 0;
  v_temqyssxx3 := 0;
  v_temqyjbxx_char := '';
  v_temqyjbxx_char2 := '';
   v_flag :=0;
   
   
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+14).col01;
         v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01;
   end if;

   if v_temqyjbxx_char is null and substr(i_sssq_q,6 ,2 )!='01' and substr(i_sssq_q,6 ,2 )!='02' and v_temqyjbxx_char2 <> '7251' and v_temqyjbxx_char2 <> '7259' and substr(i_sssq_q,0 ,2 )!='89' then
     v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+162).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+79).col02,0);
     v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col02,0);
     if v_temqyssxx1 > 0 then
       if v_temqyssxx1 >= (v_temqyssxx2 + v_temqyssxx3) * 0.06 then
         --o_retSHGS := o_retSHGS ||'(if(E162>0,E162<(E79+E92)*0.06,true))|(XXB->E14<>null)|(t(2)="01")|(t(2)="02")|(left(XXB->E4,2)="89")|(XXB->E4="7240")' || v_split;
         --o_retSHSM := o_retSHSM || '【国】【地】已缴文化事业建设费应小于增消营的6%！如有特殊情况，请填写审核说明！'|| v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000170'
             || v_split;
       end if;
     end if;
         

   end if;
end if;


/***
(if(G162>0,G162<(G79+G92+G131)*0.06,true))|(XXB->E14<>null)|(t(2)="01")|(t(2)="02")|(left(XXB->E4,2)="89")|(XXB->E4="7251")|(XXB->E4="7259")
【国】【地】上年同期已缴文化事业建设费应小于增消营的6%！如有特殊情况，请填写审核说明！
SH00000177 true
**/
if v_sb_zdsy_qyssxx.count>0 then
  v_temqyssxx1 := 0;
  v_temqyssxx2 := 0;
  v_temqyssxx3 := 0;
  v_temqyssxx4 := 0;
  v_temqyjbxx_char := '';
  v_temqyjbxx_char2 := '';
   v_flag :=0;
   
   
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+14).col01;
         v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+4).col01;
   end if;

   if v_temqyjbxx_char is null and substr(i_sssq_q,6 ,2 )!='01' and substr(i_sssq_q,6 ,2 )!='02' and v_temqyjbxx_char2 <> '7240' and v_temqyjbxx_char2 <> '7259' and substr(i_sssq_q,0 ,2 )!='89' then
     v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+162).col04,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+79).col04,0);
     v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col04,0);
     v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+131).col04,0);
     if v_temqyssxx1 > 0 then
       if v_temqyssxx1 >= (v_temqyssxx2 + v_temqyssxx3 + v_temqyssxx4) * 0.06 then
         --o_retSHGS := o_retSHGS || '(if(G162>0,G162<(G79+G92+G131)*0.06,true))|(XXB->E14<>null)|(t(2)="01")|(t(2)="02")|(left(XXB->E4,2)="89")|(XXB->E4="7240")'|| v_split;
        -- o_retSHSM := o_retSHSM || '【国】【地】上年同期已缴文化事业建设费应小于增消营的6%！如有特殊情况，请填写审核说明！'|| v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000177'
             || v_split;
       end if;
     end if;
         

   end if;
end if;


/***
if((t(2)<>"01")&(XXB->E11<>"3"),(E177>@-1E177)&(G177>@-1G177)&(E179>@-1E179)&(G179>@-1G179)&(E180>@-1E180)&(G180>@-1G180),true)
【国】其他指标中相关指标应大于上期数额，如有特殊情况，请填写审核说明！
SH00000189 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := 0;
   v_temqyssxx2 := 0;
   v_temqyjbxx := 0;
   v_gsflag := 0;
   v_flag :=0;
   --取出上期数据，暂时从本地库查出
   select t.* bulk collect into v_sb_zdsy_qyssxx_sq from sb_zdsy_qyssxx t
   where t.nsrsbh= i_nsrsbh
   and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   order by hc;
   
   if v_sb_zdsy_qyssxx_sq.count>0 then
     for i in 177 .. 180 loop
       if i = 178 then
         continue;
       end if;
        v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col02,0);
        v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+i).col04,0);
        if v_temqyssxx1 <= v_temqyssxx2 then
          v_gsflag := 1;
          exit;
        end if;
     end loop;
   end if;
   
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01;
   end if;

   if (substr(i_sssq_q,6 ,2 )!='01' and v_temqyjbxx <> 3) then
         if v_gsflag = 1 then
               --o_retSHGS := o_retSHGS || 'if((t(2)<>"01")&(XXB->E11<>"3"),(E177>@-1E177)&(G177>@-1G177)&(E179>@-1E179)&(G179>@-1G179)&(E180>@-1E180)&(G180>@-1G180),true)' || v_split;
              -- o_retSHSM := o_retSHSM || '【国】其他指标中相关指标应大于上期数额，如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000189'
                   || v_split;
         end if;
         

   end if;
end if;


/***
if((t(2)="03")|(t(2)="06")|(t(2)="09")|(t(2)="12"),(E177<=B3->H3*0.8)&(G177<=B3->J3*0.8),true)
【国】3、6、9、12月本年累计计提折旧应小于等于财务表资产总计的80%，如有特殊情况，请填写审核说明！
SH00000190 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+177).col02,0);
   v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+177).col04,0);
   v_flag :=0;
   
   if v_sb_zdsy_cwxx.count>0 then
         v_temcwxx :=v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col04;
         v_temcwxx1 :=v_sb_zdsy_cwxx(v_cwxx_baseROW+3).col06;
   end if;

   if (substr(i_sssq_q,6 ,2 ) ='03' or substr(i_sssq_q,6 ,2 ) ='06' or substr(i_sssq_q,6 ,2 ) ='09' or substr(i_sssq_q,6 ,2 ) ='12') then
         if v_temqyssxx1 > v_temcwxx * 0.8 or v_temqyssxx2 > v_temcwxx1 * 0.8 then
              -- o_retSHGS := o_retSHGS || 'if((t(2)="03")|(t(2)="06")|(t(2)="09")|(t(2)="12"),(E177<=B3->H3*0.8)&(G177<=B3->J3*0.8),true)' || v_split;
              -- o_retSHSM := o_retSHSM || '【国】3、6、9、12月本年累计计提折旧应小于等于财务表资产总计的80%，如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000190'
                   || v_split;
         end if;
         

   end if;
end if;


/***
if((t(2)<>"01"),(ABS(E178-@-1E178)<50)&(ABS(G178-@-1G178)<50),true)
【国】平均职工人数波动过大，请核实，如有特殊情况，请填写审核说明！
SH00000191 true
**/
if v_sb_zdsy_qyssxx.count>0 then
  
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+178).col02,0);
   v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+178).col04,0);
   v_temqyssxx3 := 0;
   v_temqyssxx4 := 0;
   v_flag :=0;
   
   
   --取出上期数据，暂时从本地库查出
   select t.* bulk collect into v_sb_zdsy_qyssxx_sq from sb_zdsy_qyssxx t
   where t.nsrsbh= i_nsrsbh
   and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   order by hc;
   
   if v_sb_zdsy_qyssxx_sq.count>0 then
   v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+178).col02,0);
   v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+178).col04,0);
   end if;

   if substr(i_sssq_q,6 ,2 ) <> '01' then
         if abs(v_temqyssxx1 - v_temqyssxx3) >= 50 or abs(v_temqyssxx2 - v_temqyssxx4) >= 50 then
               --o_retSHGS := o_retSHGS || 'if((t(2)<>"01"),(ABS(E178-@-1E178)<50)&(ABS(G178-@-1G178)<50),true)' || v_split;
               --o_retSHSM := o_retSHSM ||'【国】平均职工人数波动过大，请核实，如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000191'
                   || v_split;
         end if;
   end if;
   
   
end if;


/***
if((XXB->E11="1")&(t(2)<>"01"),(E181>=@-1E181)&(G181>=@-1G181)&(E182>=@-1E182)&(G182>=@-1G182)&(E183>=@-1E183)&(G183>=@-1G183)&(E184>=@-1E184)&(G184>=@-1G184),true)
【国】月度财务指标应大于上期数值，如有特殊情况，请填写审核说明！
SH00000195 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := 0;
   v_temqyssxx2 := 0;
   v_temqyjbxx := 0;
   v_gsflag := 0;
   v_flag :=0;
   --取出上期数据，暂时从本地库查出
   select t.* bulk collect into v_sb_zdsy_qyssxx_sq from sb_zdsy_qyssxx t
   where t.nsrsbh= i_nsrsbh
   and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   order by hc;
   
   if v_sb_zdsy_qyssxx_sq.count>0 then
   for i in 181 .. 184 loop
      v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col02,0);
      v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+i).col04,0);
      if v_temqyssxx1 < v_temqyssxx2 then
        v_gsflag := 1;
        exit;
      end if;
   end loop;
   end if;
   
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01;
   end if;
   

   if v_temqyjbxx = 1 and substr(i_sssq_q,6 ,2 ) <> '01' then
         if v_gsflag = 1 then
               --o_retSHGS := o_retSHGS || 'if((XXB->E11="1")&(t(2)<>"01"),(E181>=@-1E181)&(G181>=@-1G181)&(E182>=@-1E182)&(G182>=@-1G182)&(E183>=@-1E183)&(G183>=@-1G183)&(E184>=@-1E184)&(G184>=@-1G184),true)' || v_split;
               --o_retSHSM := o_retSHSM || '【国】月度财务指标应大于上期数值，如有特殊情况，请填写审核说明！'|| v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000195'
                   || v_split;
         end if;
   end if;
   
   
end if;


/***
if((t(2)<>"01")&(@-1E186<>null)&(@-1E186<>0),(E186<>null)&(E186<>0),true)
【国】1月份该指标有数，请核实本月是否漏填。如有特殊情况，请填写审核说明！
SH00000196 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := 0;
   v_temqyssxx2 := 0;
   v_temqyjbxx := 0;
   v_flag :=0;
   --取出上期数据，暂时从本地库查出
   select t.* bulk collect into v_sb_zdsy_qyssxx_sq from sb_zdsy_qyssxx t
   where t.nsrsbh= i_nsrsbh
   and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   order by hc;
   
   if v_sb_zdsy_qyssxx_sq.count>0 then
      v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+186).col02,0);
      v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+186).col02,0);
   end if;
      
   if substr(i_sssq_q,6 ,2 ) <> '01' and v_temqyssxx2 is not null and v_temqyssxx2 <> 0 then
         if v_temqyssxx1 is null or v_temqyssxx1 = 0 then
               --o_retSHGS := o_retSHGS ||'if((t(2)<>"01")&(@-1E186<>null)&(@-1E186<>0),(E186<>null)&(E186<>0),true)' || v_split;
              -- o_retSHSM := o_retSHSM || '【国】1月份该指标有数，请核实本月是否漏填。如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000196'
                   || v_split;
         end if;
   end if;
   
   
end if;


/***
if((t(2)<>"01")&(@-1G186<>null)&(@-1G186<>0),(G186<>null)&(G186<>0),true)
【国】1月份该指标有数，请核实本月是否漏填。如有特殊情况，请填写审核说明！
SH00000197 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := 0;
   v_temqyssxx2 := 0;
   v_temqyjbxx := 0;
   v_flag :=0;
   --取出上期数据，暂时从本地库查出
   select t.* bulk collect into v_sb_zdsy_qyssxx_sq from sb_zdsy_qyssxx t
   where t.nsrsbh= i_nsrsbh
   and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
   order by hc;
   
   if v_sb_zdsy_qyssxx_sq.count>0 then
      v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+186).col04,0);
      v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx_sq(v_qyssxx_baseROW+186).col04,0);
   end if;
   
   if substr(i_sssq_q,6 ,2 ) <> '01' and v_temqyssxx2 is not null and v_temqyssxx2 <> 0 then
         if v_temqyssxx1 is null or v_temqyssxx1 = 0 then
               --o_retSHGS := o_retSHGS || 'if((t(2)<>"01")&(@-1G186<>null)&(@-1G186<>0),(G186<>null)&(G186<>0),true)' || v_split;
               --o_retSHSM := o_retSHSM || '【国】1月份该指标有数，请核实本月是否漏填。如有特殊情况，请填写审核说明！' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000197'
                   || v_split;
         end if;
   end if;
   
   
end if;


/***
if((XXB->E12<>"00")&(t(2)>"05"),(sum(B1->F3:B1->F83)<>0),true)
【国】增值税纳税人必须填写增值税相关指标，如有特殊情况，请填写审核说明！
SH00000261 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := 0;
   v_temqyjbxx_char := '';
   v_flag :=0;
   
   for i in 3 .. 83 loop
      v_temqyssxx1 := v_temqyssxx1 + nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+i).col03,0);
      
   end loop;
   
   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+12).col01;
   end if;
      
   if substr(i_sssq_q,6 ,2 ) > '05' and v_temqyjbxx_char <> '00' then
         if v_temqyssxx1 = 0 then
               --o_retSHGS := o_retSHGS ||'if((XXB->E12<>"00")&(t(2)>"05"),(sum(B1->F3:B1->F83)<>0),true)' || v_split;
               --o_retSHSM := o_retSHSM || '【国】增值税纳税人必须填写增值税相关指标，如有特殊情况，请填写审核说明！'|| v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000261'
                   || v_split;
         end if;
   end if;
   
   
end if;


/*
          税收表表内上期数据
          说明：
              1. 增加v_sb_zdsy_qyssxx_sq    t_sb_zdsy_qyssxx_rowtype;--定义税收信息表变量(上期数据)
*/

/***
(([D58,F58]>=0)|(t(2)<>"01"))
【国】1月份的增值税上期留抵税额应大于等于0！如有特殊情况，请填写审核说明！
SH00000094 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyjbxx_char := '';
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+58).col01,0);
   v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+58).col03,0);
   v_flag :=0;
      
   if substr(i_sssq_q,6 ,2 ) = '01' and v_temqyssxx1 < 0 then
     if v_flag<>1 then
       --o_retSHGS := o_retSHGS || '(([D58,F58]>=0)|(t(2)<>"01"))'|| v_split;
       --o_retSHSM := o_retSHSM || '【国】1月份的增值税上期留抵税额应大于等于0！如有特殊情况，请填写审核说明！' || v_split;
       o_retSHBJ := o_retSHBJ ||
          'SH00000094'
           || v_split;
         v_flag :=1;  
     end if;
   end if;
   
   if substr(i_sssq_q,6 ,2 ) = '01' and v_temqyssxx2 < 0 then
     if v_flag<>1 then
       --o_retSHGS := o_retSHGS ||'(([D58,F58]>=0)|(t(2)<>"01"))' || v_split;
       --o_retSHSM := o_retSHSM ||'【国】1月份的增值税上期留抵税额应大于等于0！如有特殊情况，请填写审核说明！'|| v_split;
       o_retSHBJ := o_retSHBJ ||
          'SH00000094'
           || v_split;
            v_flag :=1;  
     end if;
   end if;
   
   
end if;



/***
(if((D89=0)&(D92<>0)&(D90<>D92),(abs(D92-D91)<0.5),true))|(t(2)="01")
【国】消费税本期已缴税额应该等于期初未缴税额！如有特殊情况，请填写审核说明！
SH00000120 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+89).col01,0);
   v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+90).col01,0);
   v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+91).col01,0);
   v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col01,0);
   v_flag :=0;
      
   if substr(i_sssq_q,6 ,2 ) <> '01' then
     if v_temqyssxx1 = 0 and v_temqyssxx4 <> 0 and v_temqyssxx2 <> v_temqyssxx4 then
       if abs(v_temqyssxx4 - v_temqyssxx3) > 0.5 then
         --o_retSHGS := o_retSHGS || '(if((D89=0)&(D92<>0)&(D90<>D92),(abs(D92-D91)<0.5),true))|(t(2)="01")'|| v_split;
        -- o_retSHSM := o_retSHSM || '【国】消费税本期已缴税额应该等于期初未缴税额！如有特殊情况，请填写审核说明！' || v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000120'
             || v_split;
       end if;
     end if;
   end if;
   
   
end if;


/***
(if((F89=0)&(F92<>0)&(F90<>F92),(abs(F92-F91)<0.5),true))|(t(2)="01")
【国】消费税本期已缴税额应该等于期初未缴税额！如有特殊情况，请填写审核说明！
SH00000121 true
**/
if v_sb_zdsy_qyssxx.count>0 then
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+89).col03,0);
   v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+90).col03,0);
   v_temqyssxx3 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+91).col03,0);
   v_temqyssxx4 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col03,0);
   v_flag :=0;
      
   if substr(i_sssq_q,6 ,2 ) <> '01' then
     if v_temqyssxx1 = 0 and v_temqyssxx4 <> 0 and v_temqyssxx2 <> v_temqyssxx4 then
       if abs(v_temqyssxx4 - v_temqyssxx3) > 0.5 then
         --o_retSHGS := o_retSHGS || '(if((F89=0)&(F92<>0)&(F90<>F92),(abs(F92-F91)<0.5),true))|(t(2)="01")' || v_split;
         --o_retSHSM := o_retSHSM || '【国】消费税本期已缴税额应该等于期初未缴税额！如有特殊情况，请填写审核说明！' || v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000121'
             || v_split;
       end if;
     end if;
   end if;
   
   
end if;


/***
(if(([E113,G113]<>0)&([E113,G113]<>null)&([E27,G27]<>0)&([E27,G27]<>null),[E113,G113]<=[E27,G27],true)|(t(2)<"03"))
【国】已缴进口环节增值税<=进项税额！如有特殊情况，请填写审核说明！
SH00000145 true
**/
if v_sb_zdsy_qyssxx.count>0 then
  v_temqyssxx1 := 0;
  v_temqyssxx2 := 0;
   v_flag :=0;
      
   if substr(i_sssq_q,6 ,2 ) >= '03' then
     v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+113).col02,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+27).col02,0);
     if v_temqyssxx1 <> 0 and v_temqyssxx1 is not null and v_temqyssxx2 <> 0 and v_temqyssxx2 is not null then
       if v_temqyssxx1 > v_temqyssxx2 then
         if v_flag<>1 then
         --o_retSHGS := o_retSHGS || '(if(([E113,G113]<>0)&([E113,G113]<>null)&([E27,G27]<>0)&([E27,G27]<>null),[E113,G113]<=[E27,G27],true)|(t(2)<"03"))' || v_split;
        -- o_retSHSM := o_retSHSM || '【国】已缴进口环节增值税<=进项税额！如有特殊情况，请填写审核说明！' || v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000145'
             || v_split;
             v_flag := 1;
         end if;
       end if;
     end if;
   end if;
   
   if substr(i_sssq_q,6 ,2 ) >= '03' then
     v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+113).col04,0);
     v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+27).col04,0);
     if v_temqyssxx1 <> 0 and v_temqyssxx1 is not null and v_temqyssxx2 <> 0 and v_temqyssxx2 is not null then
       if v_temqyssxx1 > v_temqyssxx2 then
         if v_flag<>1 then
         --o_retSHGS := o_retSHGS || '(if(([E113,G113]<>0)&([E113,G113]<>null)&([E27,G27]<>0)&([E27,G27]<>null),[E113,G113]<=[E27,G27],true)|(t(2)<"03"))'|| v_split;
        -- o_retSHSM := o_retSHSM || '【国】已缴进口环节增值税<=进项税额！如有特殊情况，请填写审核说明！' || v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000145'
             || v_split;
             v_flag := 1;
          end if;
       end if;
     end if;
   end if;
   
   
end if;



/***
([E163,G163]/[E178,G178]<=100)|(%JB%)
【国】【地】平均职工的社保基金应小于100万！如有特殊情况，请填写审核说明！
SH00000174 true
**/
if v_sb_zdsy_qyssxx.count>0 then
  v_temqyssxx1 := 0;
  v_temqyssxx2 := 0;
   v_flag :=0;
     
  v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+163).col02,0);
  v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+178).col02,0); 
   if v_temqyssxx2 <> 0 and v_temqyssxx1/v_temqyssxx2 > 100 then
         if v_flag<>1 then
         --o_retSHGS := o_retSHGS || '([E163,G163]/[E178,G178]<=100)|(%JB%)' || v_split;
         --o_retSHSM := o_retSHSM || '【国】【地】平均职工的社保基金应小于100万！如有特殊情况，请填写审核说明！' || v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000174'
             || v_split;
             v_flag := 1;
     end if;
   end if;
   
   v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+163).col04,0);
  v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+178).col04,0); 
   if v_temqyssxx2 <> 0 and v_temqyssxx1/v_temqyssxx2 > 100 then
         if v_flag<>1 then
         --o_retSHGS := o_retSHGS || '([E163,G163]/[E178,G178]<=100)|(%JB%)' || v_split;
         --o_retSHSM := o_retSHSM ||'【国】【地】平均职工的社保基金应小于100万！如有特殊情况，请填写审核说明！' || v_split;
         o_retSHBJ := o_retSHBJ ||
            'SH00000174'
             || v_split;
             v_flag := 1;
     end if;
   end if;
   
end if;


  END P_SB_BJJY_QYSSXX;


  ---------------------------------------------------------------------------------------------------
  --=================================================================================================
  ---------------------------以下方法为：产品表---------------------------------------------
  --=================================================================================================
  ---------------------------------------------------------------------------------------------------
--产品信息表校验
  procedure P_SB_BJJY_CPSSB(
     i_nsrsbh   IN       VARCHAR2,--纳税人识别号
   i_sssq_q   IN       VARCHAR2,--所属时期起
   i_sssq_z   IN       VARCHAR2,--所属时期止
   o_retSHGS     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHSM     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHBJ     OUT      CLOB  --返回检查结果，如果有空字符或者字符串长度为0
)
is
   /**
   * 重点税源表间关系校验
   * 2017.01.07 tongbinbin
   *增加校验关系：
   */
   type t_sb_zdsy_cwxx_rowtype is table of sb_zdsy_cwxx%rowtype index by binary_integer; --定义财务信息表类型
   type t_sb_zdsy_qyssxx_rowtype is table of sb_zdsy_qyssxx%rowtype index by binary_integer; --定义企业税收信息表类型
   type t_sb_zdsy_cpssb_rowtype is table of sb_zdsy_cpssb%rowtype index by binary_integer; --定义主要产品税收表类型
   type t_sb_zdsy_qyjbxx_rowtype is table of sb_zdsy_qyjbxx%rowtype index by binary_integer; --定义基本信息表类型
   type t_sb_zdsy_jqdcwj_rowtype is table of sb_zdsy_jqdcwj%rowtype index by binary_integer; --定义调查问卷表类型

   v_sb_zdsy_cwxx t_sb_zdsy_cwxx_rowtype;--定义财务信息表变量
   v_sb_zdsy_qyssxx t_sb_zdsy_qyssxx_rowtype;--定义企业税收信息表变量
   v_sb_zdsy_cpssb t_sb_zdsy_cpssb_rowtype;--定义主要产品税收表变量
   v_sb_zdsy_qyjbxx t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量
   v_sb_zdsy_jqdcwj t_sb_zdsy_jqdcwj_rowtype;--定义调查问卷表变量


   v_wcfw INT DEFAULT 0;         --误差范围为1元, 2017.01.07不允许误差，设定误差为0
   v_temcwxx              NUMBER (16, 2);--财务信息表变量
   v_temqyssxx            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx1            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx2            NUMBER (16, 2);--企业税收信息表变量
   v_temcpssb             NUMBER (16, 2);--主要产品税收表变量
   v_temcpssb1             NUMBER (16, 2);--主要产品税收表变量
   v_temcpssb2             NUMBER (16, 2);--主要产品税收表变量
   v_temqyjbxx            NUMBER (16, 2);--基本信息表变量
   v_temjqdcwj            NUMBER (16, 2);--调查问卷表变量
   v_count              NUMBER;
   v_qyjbxx_baseROW           NUMBER;
   v_cpssb_baseROW           NUMBER;
   v_qyssxx_baseROW        NUMBER;
   v_split                   varchar2(10) := ',';
   v_flag varchar2(1) := 0;--用于标记是否保存过该公式
BEGIN

v_qyjbxx_baseROW:=0;
v_qyssxx_baseROW:=-2;
v_cpssb_baseROW:=0;

   select * bulk collect into v_sb_zdsy_cwxx --给财务信息表变量赋值
     from sb_zdsy_cwxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyssxx --给企业税收信息表变量赋值
     from sb_zdsy_qyssxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_cpssb --给主要产品税收表变量赋值
     from sb_zdsy_cpssb t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyjbxx --给基本信息表变量赋值
     from sb_zdsy_qyjbxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_jqdcwj --给调查问卷表变量赋值
     from sb_zdsy_jqdcwj t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;



/****
************************************************************************************
********************************请在下方增加校验*************************************
************************************************************************************
****/



/**************************************************0309产品表******************************************************************/
/***
1.if(XXB->E13<>"0",([AC5,AD5]>=[AE5,AF5]),true)
【国】【地】享受免抵退政策的企业，销售收入应大于等于出口销售收入！如有特殊情况，请填写审核说明！
SH00000202 true
**/
if v_sb_zdsy_cpssb.count>0 then
   v_temqyssxx:=0;
   v_temcpssb1:=0;
   v_temcpssb2:=0;
   v_flag :=0;

   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyssxx_baseROW+13).col01,0);
   end if;


   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     
     for i in 1 .. v_sb_zdsy_cpssb.count loop
      v_temcpssb1 := nvl(v_sb_zdsy_cpssb(i).col31,0);
      v_temcpssb2 := nvl(v_sb_zdsy_cpssb(i).col33,0);
       if (v_temqyjbxx <> 0 and v_temcpssb1 < v_temcpssb2) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || 'if(XXB->E13<>"0",([AC5,AD5]>=[AE5,AF5]),true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】享受免抵退政策的企业，销售收入应大于等于出口销售收入！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000202'
               || v_split;
           v_flag :=1;
         end if;
       end if;


       v_temcpssb1 := nvl(v_sb_zdsy_cpssb(i).col32,0);
      v_temcpssb2 := nvl(v_sb_zdsy_cpssb(i).col34,0);
       if (v_temqyjbxx <> 0 and v_temcpssb1 < v_temcpssb2) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || 'if(XXB->E13<>"0",([AC5,AD5]>=[AE5,AF5]),true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】享受免抵退政策的企业，销售收入应大于等于出口销售收入！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000202'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     end loop;
     
     
   end if;
end if;


/***
2.if(XXB->E13<>"0",([AC5,AD5]>=[AG5,AH5]),true)
【国】【地】享受免抵退政策的企业，销售收入应大于等于免税销售收入！如有特殊情况，请填写审核说明！
SH00000203 true
**/
if v_sb_zdsy_cpssb.count>0 then
   v_temqyssxx:=0;
   v_temcpssb1:=0;
   v_temcpssb2:=0;
   v_flag :=0;

   if v_sb_zdsy_qyjbxx.count>0 then
         v_temqyjbxx := nvl(v_sb_zdsy_qyjbxx(v_qyssxx_baseROW+13).col01,0);
   end if;


   if v_temqyjbxx <>0 and v_temqyjbxx is not null then
     for i in 1 .. v_sb_zdsy_cpssb.count loop
      v_temcpssb1 := nvl(v_sb_zdsy_cpssb(i).col31,0);
      v_temcpssb2 := nvl(v_sb_zdsy_cpssb(i).col35,0);
       if (v_temqyjbxx <> 0 and v_temcpssb1 < v_temcpssb2) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || 'if(XXB->E13<>"0",([AC5,AD5]>=[AG5,AH5]),true)'  || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】享受免抵退政策的企业，销售收入应大于等于免税销售收入！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000203'
               || v_split;
           v_flag :=1;
         end if;
       end if;


       v_temcpssb1 := nvl(v_sb_zdsy_cpssb(i).col32,0);
      v_temcpssb2 := nvl(v_sb_zdsy_cpssb(i).col36,0);
       if (v_temqyjbxx <> 0 and v_temcpssb1 < v_temcpssb2) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || 'if(XXB->E13<>"0",([AC5,AD5]>=[AG5,AH5]),true)' || v_split;
           --o_retSHSM := o_retSHSM || '【国】【地】享受免抵退政策的企业，销售收入应大于等于免税销售收入！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000203'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     end loop;

   end if;
end if;



/***
3.IF(B2->AI5<>0,B2->AI5<=(B1->E77+B1->E90),TRUE)
【国】【地】本年应税税收收入应小于等于增值税、消费税税收收入合计！如有特殊情况，请填写审核说明！
SH00000206 true
**/
if v_sb_zdsy_cpssb.count>0 then
   v_temqyssxx1:=0;
   v_temqyssxx2:=0;
   v_temcpssb:=0;
   v_flag :=0;

   if v_sb_zdsy_qyssxx.count>0 then
         v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+77).col02,0);
         v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+90).col02,0);
   end if;

   if (v_temqyssxx1 is not null and v_temqyssxx2 is not null)then
     for i in 1 .. v_sb_zdsy_cpssb.count loop
       v_temcpssb := nvl(v_sb_zdsy_cpssb(i).col37,0);
       if (v_temcpssb <> 0 and v_temcpssb > (v_temqyssxx1 + v_temqyssxx2)) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS || 'IF(B2->AI5<>0,B2->AI5<=(B1->E77+B1->E90),TRUE)' || v_split;
           --o_retSHSM := o_retSHSM ||'【国】【地】本年应税税收收入应小于等于增值税、消费税税收收入合计！如有特殊情况，请填写审核说明！' || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000206'
               || v_split;
           v_flag :=1;
           exit;
         end if;
       end if;
     end loop;
      


   end if;
end if;


/***
4.IF(B2->AJ5<>0,B2->AJ5<=(B1->G77+B1->G90),TRUE)
【国】【地】本年应税税收收入应小于等于增值税、消费税税收收入合计！如有特殊情况，请填写审核说明！
SH00000207 true
**/
if v_sb_zdsy_cpssb.count>0 then
   v_temqyssxx1:=0;
   v_temqyssxx2:=0;
   v_temcpssb:=0;
   v_flag :=0;

   if v_sb_zdsy_qyssxx.count>0 then
         v_temqyssxx1 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+77).col04,0);
         v_temqyssxx2 := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+90).col04,0);
   end if;


   if (v_temqyssxx1 is not null and v_temqyssxx2 is not null)then
     for i in 1 .. v_sb_zdsy_cpssb.count loop
      v_temcpssb := nvl(v_sb_zdsy_cpssb(i).col38,0);
       if (v_temcpssb <> 0 and v_temcpssb > (v_temqyssxx1 + v_temqyssxx2)) then
         if v_flag<>1 then
           --o_retSHGS := o_retSHGS ||  'IF(B2->AJ5<>0,B2->AJ5<=(B1->G77+B1->G90),TRUE)' || v_split;
           --o_retSHSM := o_retSHSM ||'【国】【地】上年应税税收收入应小于等于增值税、消费税税收收入合计！如有特殊情况，请填写审核说明！'  || v_split;
           o_retSHBJ := o_retSHBJ ||
              'SH00000207'
               || v_split;
           v_flag :=1;
         end if;
       end if;
     end loop;

   end if;
end if;


  END P_SB_BJJY_CPSSB;


   ---------------------------------------------------------------------------------------------------
  --=================================================================================================
  ---------------------------以下方法为：基本信息表---------------------------------------------
  --=================================================================================================
  ---------------------------------------------------------------------------------------------------
--基本信息表校验
  procedure P_SB_BJJY_QYJBXX(
   i_nsrsbh   IN       VARCHAR2,--纳税人识别号
   i_sssq_q   IN       VARCHAR2,--所属时期起
   i_sssq_z   IN       VARCHAR2,--所属时期止
   o_retSHGS     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHSM     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHBJ     OUT      CLOB  --返回检查结果，如果有空字符或者字符串长度为0
)
is
   /**
   * 重点税源表间关系校验
   * 2017.01.07 tongbinbin
   *增加校验关系：
   */
   type t_sb_zdsy_cwxx_rowtype is table of sb_zdsy_cwxx%rowtype index by binary_integer; --定义财务信息表类型
   type t_sb_zdsy_qyssxx_rowtype is table of sb_zdsy_qyssxx%rowtype index by binary_integer; --定义企业税收信息表类型
   type t_sb_zdsy_cpssb_rowtype is table of sb_zdsy_cpssb%rowtype index by binary_integer; --定义主要产品税收表类型
   type t_sb_zdsy_qyjbxx_rowtype is table of sb_zdsy_qyjbxx%rowtype index by binary_integer; --定义基本信息表类型
   type t_sb_zdsy_jqdcwj_rowtype is table of sb_zdsy_jqdcwj%rowtype index by binary_integer; --定义调查问卷表类型

   --增加变量
   v_sb_zdsy_qyjbxx_sq    t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量(上期数据)


   v_sb_zdsy_cwxx           t_sb_zdsy_cwxx_rowtype;--定义财务信息表变量
   v_sb_zdsy_qyssxx         t_sb_zdsy_qyssxx_rowtype;--定义企业税收信息表变量
   v_sb_zdsy_cpssb          t_sb_zdsy_cpssb_rowtype;--定义主要产品税收表变量
   v_sb_zdsy_qyjbxx         t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量
   v_sb_zdsy_jqdcwj         t_sb_zdsy_jqdcwj_rowtype;--定义调查问卷表变量

   type t_jqdcwj_arr is table of number;
   v_jqdcwj_arr  t_jqdcwj_arr;

   v_wcfw INT DEFAULT 0;         --误差范围为1元, 2017.01.07不允许误差，设定误差为0
   v_temqyjbxx_char        CLOB;--企业基本信息字符串类型变量
   v_temqyjbxx_char2      varchar2(10);--企业基本信息字符串类型变量
   v_temqyjbxx_char3      varchar2(10);--企业基本信息字符串类型变量
   v_temcwxx1              NUMBER (16, 2);--财务信息表变量
   v_temcwxx2              NUMBER (16, 2);--财务信息表变量
   v_temcwxx3              NUMBER (16, 2);--财务信息表变量
   v_temcwxx4              NUMBER (16, 2);--财务信息表变量
   v_temcwxx5              NUMBER (16, 2);--财务信息表变量
   v_temcwxx6              NUMBER (16, 2);--财务信息表变量
   v_temcwxx7              NUMBER (16, 2);--财务信息表变量
   v_temcwxx8              NUMBER (16, 2);--财务信息表变量
   v_temcwxx9              NUMBER (16, 2);--财务信息表变量
   v_temqyssxx             NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx2            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx3            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx4            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx5            NUMBER (16, 2);--企业税收信息表变量
   v_temcpssb             NUMBER (16, 2);--主要产品税收表变量
   v_temqyjbxx            NUMBER (16, 2);--基本信息表变量
   v_temjqdcwj            NUMBER (16, 2);--调查问卷表变量
   v_temjqdcwj2            NUMBER (16, 2);--调查问卷表变量
   v_qyjbxx_baseROW           NUMBER;
   v_cwxx_baseROW        NUMBER;
   v_qyssxx_baseROW     NUMBER;
   v_jqdcwj_baseROW     NUMBER;
   v_split                   varchar2(10) := ',';
   v_flag varchar2(1) := 0;--用于标记是否保存过该公式
BEGIN

v_qyjbxx_baseROW:=0;
v_qyssxx_baseROW:=-2;
v_cwxx_baseROW:=0;
v_jqdcwj_baseROW :=0;


   select * bulk collect into v_sb_zdsy_cwxx --给财务信息表变量赋值
     from sb_zdsy_cwxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyssxx --给企业税收信息表变量赋值
     from sb_zdsy_qyssxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_cpssb --给主要产品税收表变量赋值
     from sb_zdsy_cpssb t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyjbxx --给基本信息表变量赋值
     from sb_zdsy_qyjbxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_jqdcwj --给调查问卷表变量赋值
     from sb_zdsy_jqdcwj t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;




    /*================================================================================
       ============================  企业基本信息表标间校验  ==============================
      ================================================================================*/


      --（一）基本信息表与B1表进行表间校验
      if v_sb_zdsy_qyssxx.count >0 and v_sb_zdsy_qyjbxx.count>0 then
               --(if((B1->E3+B1->E7+B1->E9+B1->E10>0)|(B1->E77>0),(E12<>null)&(E12<>"00"),true))
          /*
            (
               if(
                    (B1->E3+B1->E7+B1->E9+B1->E10>0)|(B1->E77>0),
                    (E12<>null)&(E12<>"00"),
                    true
                )
            )
          */
          --1.【国】有计征增值税销售额或者有增值税应缴税款的企业，应填写增值税缴纳方式！如有特殊情况，请填写审核说明！
          --表间（B1）SH00000021   TRUE
          v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+3).col02,0);
          v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+7).col02,0);
          v_temqyssxx3 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+9).col02,0);
          v_temqyssxx4 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+10).col02,0);
          v_temqyssxx5 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+77).col02,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+12).col01;
          if v_temqyssxx+v_temqyssxx2+v_temqyssxx3+v_temqyssxx4 >0 or v_temqyssxx5>0 then
             if v_temqyjbxx_char is null or v_temqyjbxx_char='00' then
                --o_retSHGS := o_retSHGS ||  '(if((B1->E3+B1->E7+B1->E9+B1->E10>0)|(B1->E77>0),(E12<>null)&(E12<>"00"),true))'  || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有计征增值税销售额或者有增值税应缴税款的企业，应填写增值税缴纳方式！如有特殊情况，请填写审核说明！'  || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000021'
                     || v_split;
             end if;
          end if;


           --(if((B1->D9<>0)|(B1->D60<>0)|(B1->D116<>0)|(B1->D117<>0),(E13<>null)&(E13<>"0"),true))
          /*
            (
                if(
                   (B1->D9<>0)|(B1->D60<>0)|(B1->D116<>0)|(B1->D117<>0),
                   (E13<>null)&(E13<>"0"),
                   true
                 )
            )
          */
          --2.【国】有进出口税收（免、抵、退税办法出口货物销售额、免抵退货物应退税额、实际收到的出口货物退税额（负数）），必须填写增值税出口退税方式！如有特殊情况，请填写审核说明！
          --表间（B1） SH00000023 TRUE
          v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+9).col01,0);
          v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+60).col01,0);
          v_temqyssxx3 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+116).col01,0);
          v_temqyssxx4 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+117).col01,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+13).col01;
          if v_temqyssxx!=0 or v_temqyssxx2!=0 or v_temqyssxx3!=0 or v_temqyssxx4!=0 then
             if v_temqyjbxx_char is null or v_temqyjbxx_char = '0' then
                --o_retSHGS := o_retSHGS || '(if((B1->D9<>0)|(B1->D60<>0)|(B1->D116<>0)|(B1->D117<>0),(E13<>null)&(E13<>"0"),true))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有进出口税收（免、抵、退税办法出口货物销售额、免抵退货物应退税额、实际收到的出口货物退税额（负数）），必须填写增值税出口退税方式！如有特殊情况，请填写审核说明！' || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000023'
                     || v_split;
             end if;
          end if;


          --(if((B1->E84>0)|(B1->E90>0),(E15<>null)&(E15<>"0"),true))
          /*
             (
                if(
                    (B1->E84>0)|(B1->E90>0),
                    (E15<>null)&(E15<>"0"),
                    true
                 )
             )
          */
          --3.【国】有应征消费税的销售额或有消费税应缴税款，必须填写消费税缴纳方式认定情况！如有特殊情况，请填写审核说明！
          --表间（B1） SH00000026 TRUE
          v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+84).col02,0);
          v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+90).col02,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+15).col01;
          if v_temqyssxx>0 or v_temqyssxx2>0 then
             if v_temqyjbxx_char is null or v_temqyjbxx_char='0' then
                  --o_retSHGS := o_retSHGS || '(if((B1->E84>0)|(B1->E90>0),(E15<>null)&(E15<>"0"),true))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有应征消费税的销售额或有消费税应缴税款，必须填写消费税缴纳方式认定情况！如有特殊情况，请填写审核说明！'  || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000026'
                     || v_split;
             end if;
          end if;


          --(if(B1->D84+B1->D90<>0,E16<>null,true))
          /*
               (
                   if(
                        B1->D84+B1->D90<>0,
                        E16<>null,
                        true
                    )
               )
          */
          --4.【国】有消费税应征消费税的销售额、应纳税额的企业，必须填写消费税主要品目！如有特殊情况，请填写审核说明！
          --表间（B1） SH00000029 TRUE
          v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+84).col01,0);
          v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+90).col01,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+16).col01;
          if v_temqyssxx+v_temqyssxx2 != 0 then
              if v_temqyjbxx_char is null then
                  --o_retSHGS := o_retSHGS || '(if(B1->D84+B1->D90<>0,E16<>null,true))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有消费税应征消费税的销售额、应纳税额的企业，必须填写消费税主要品目！如有特殊情况，请填写审核说明！' || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000029'
                     || v_split;
              end if;
          end if;


          --(if((B1->E107>0)|(B1->E108>0)|(E11="1")|(E11="2"),E17<>null,true))
          /*
             (
                if(
                      (B1->E107>0)|(B1->E108>0)|(E11="1")|(E11="2"),
                      E17<>null,
                      true
                 )
             )
          */
          --5.【国】有企业所得税有应纳、已预缴税额或者企业财务核算方式为独立核算、按月或按季编制报表时，必须填写企业所得税缴纳方式认定情况！如有特殊情况，请填写审核说明！
          --表间（B1） SH00000031 TRUE
          v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+107).col02,0);
          v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+108).col02,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01;
          v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01;
          if v_temqyssxx>0 or v_temqyssxx2>0 or v_temqyjbxx_char='1' or v_temqyjbxx_char='2' then
             if v_temqyjbxx_char2 is null then
                 --o_retSHGS := o_retSHGS || '(if((B1->E107>0)|(B1->E108>0)|(E11="1")|(E11="2"),E17<>null,true))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有企业所得税有应纳、已预缴税额或者企业财务核算方式为独立核算、按月或按季编制报表时，必须填写企业所得税缴纳方式认定情况！如有特殊情况，请填写审核说明！'  || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000031'
                     || v_split;
             end if;
          end if;


          --(if(B1->D105>0,(E18<>null)&(E18<>"040100"),true))
          /*
              (
                 if(
                      B1->D105>0,
                      (E18<>null)&(E18<>"040100"),
                      true
                   )
              )
          */
          --6.【国】有企业所得税减免应缴税款，必须填写缴纳方式优惠政策形式！如有特殊情况，请填写审核说明！
          --表间（B1） SH00000034 TRUE
          v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+105).col01,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+18).col01;
          if v_temqyssxx>0 then
             if v_temqyjbxx_char is null or v_temqyjbxx_char='040100' then
               --o_retSHGS := o_retSHGS || '(if(B1->D105>0,(E18<>null)&(E18<>"040100"),true))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有企业所得税减免应缴税款，必须填写缴纳方式优惠政策形式！如有特殊情况，请填写审核说明！'  || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000034'
                     || v_split;
             end if;
          end if;


          --(if((B1->D108+B1->D110+B1->D112>0)|(B1->D107>0),E19<>null,true))
          /*
              (
                  if(
                       (B1->D108+B1->D110+B1->D112>0)|(B1->D107>0),
                       E19<>null,
                       true
                    )
               )
          */
          --7.【国】有企业所得税已缴、应缴税额的企业，必须填写企业所得税缴纳方式和企业所得税国、地税征收隶属关系！如有特殊情况，请填写审核说明！
          --表间（B1） SH00000037 TRUE
          v_temqyssxx := nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+108).col01,0);
          v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+110).col01,0);
          v_temqyssxx3 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+112).col01,0);
          v_temqyssxx4 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+107).col01,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+19).col01;
          if v_temqyssxx+v_temqyssxx2+v_temqyssxx3>0 or v_temqyssxx4>0 then
              if v_temqyjbxx_char is null then
                  --o_retSHGS := o_retSHGS || '(if((B1->D108+B1->D110+B1->D112>0)|(B1->D107>0),E19<>null,true))'  || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有企业所得税已缴、应缴税额的企业，必须填写企业所得税缴纳方式和企业所得税国、地税征收隶属关系！如有特殊情况，请填写审核说明！' || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000037'
                     || v_split;
              end if;
          end if;


          --((if(B1->E107>0,[E17,E19]<>null,true)))
          /*
              (
                 (
                    if(
                       B1->E107>0,
                       [E17,E19]<>null,
                       true
                     )
                 )
              )
          */
          --8.【国】有企业所得税应纳税额合计的企业，需填写企业所得税缴纳方式和企业所得税国、地税征收隶属关系！如有特殊情况，请填写审核说明！
          --表间（B1） SH00000038 TRUE
          v_temqyssxx :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+107).col02,0);
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+17).col01;
          v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+19).col01;
          if v_temqyssxx>0 then
             if v_temqyjbxx_char is null or v_temqyjbxx_char2 is null then
                  --o_retSHGS := o_retSHGS || '((if(B1->E107>0,[E17,E19]<>null,true)))' || v_split;
                 --o_retSHSM := o_retSHSM || '【国】有企业所得税应纳税额合计的企业，需填写企业所得税缴纳方式和企业所得税国、地税征收隶属关系！如有特殊情况，请填写审核说明！' || v_split;
                 o_retSHBJ := o_retSHBJ ||
                    'SH00000038'
                     || v_split;
             end if;
          end if;

      end if;


      --（二）与上期数据比较
      /*
          说明：
              1. 增加v_sb_zdsy_qyjbxx_sq    t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量(上期数据)
      */
      --非一月份申报数据
      if v_sb_zdsy_qyjbxx.count>0 and substr(i_sssq_q,6 ,2 )!='01' then
         --取出上期数据，暂时从本地库查出
         select t.* bulk collect into v_sb_zdsy_qyjbxx_sq from sb_zdsy_qyjbxx t
         where t.nsrsbh= i_nsrsbh
         and t.sssq_q= to_char(add_months(to_date(i_sssq_q,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
         and t.sssq_z= to_char(add_months(to_date(i_sssq_z,'yyyy-mm-dd'),-1),'yyyy-mm-dd')
         order by hc;
         if v_sb_zdsy_qyjbxx_sq.count>0 then--上期有数据时
              --E3（企业名称）不为空时
              v_temqyjbxx_char := v_sb_zdsy_qyjbxx(3+v_qyjbxx_baseROW).col01;
              if v_temqyjbxx_char!='' then
                   --(if(@-1XXB->E3<>"",E4=@-1E4,true))|(t(2)="01")
                   --【国】国民经济行业类别代码较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000006 TRUE
                  v_temqyjbxx_char2 := v_sb_zdsy_qyjbxx(4+v_qyjbxx_baseROW).col01;
                  v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(4+v_qyjbxx_baseROW).col01;
                  if v_temqyjbxx_char2!=v_temqyjbxx_char3 then
                     --o_retSHGS := o_retSHGS || '(if(@-1XXB->E3<>"",E4=@-1E4,true))|(t(2)="01")' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】国民经济行业类别代码较上期有变动，请核实！如有特殊情况，请填写审核说明！' || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000006'
                         || v_split;
                 end if;

                   --(if(@-1XXB->E3<>"",E6=@-1E6,true))|(t(2)="01")
                   --【国】企业工商登记注册类型代码较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000010 TRUE
                   v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(6+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(6+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS ||  '(if(@-1XXB->E3<>"",E4=@-1E4,true))|(t(2)="01")'  || v_split;
                       --o_retSHSM := o_retSHSM ||  '【国】国民经济行业类别代码较上期有变动，请核实！如有特殊情况，请填写审核说明！' || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000010'
                           || v_split;
                   end if;

                   --(if(@-1XXB->E3<>"",E7=@-1E7,true))|(t(2)="01")
                   --【国】企业工商营业执照的登记时间较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000012
                   v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(7+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(7+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS || '(if(@-1XXB->E3<>"",E7=@-1E7,true))|(t(2)="01")' || v_split;
                       --o_retSHSM := o_retSHSM || '【国】企业工商营业执照的登记时间较上期有变动，请核实！如有特殊情况，请填写审核说明！' || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000012'
                           || v_split;
                   end if;

                   --(if(@-1XXB->E3<>"",E8=@-1E8,true))|(t(2)="01")
                   --【国】主要投资方所属国家或地区较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000013 TRUE
                   v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(8+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(8+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS || '(if(@-1XXB->E3<>"",E8=@-1E8,true))|(t(2)="01")' || v_split;
                       --o_retSHSM := o_retSHSM || '【国】主要投资方所属国家或地区较上期有变动，请核实！如有特殊情况，请填写审核说明！ ' || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000013'
                           || v_split;
                   end if;

                   --(if(@-1XXB->E3<>"",E14=@-1E14,true))|(t(2)="01")
                   --【国】营业税改增值税应税服务类型较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000024 TRUE
                   v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(14+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(14+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS ||  '(if(@-1XXB->E3<>"",E14=@-1E14,true))|(t(2)="01")  ' || v_split;
                       --o_retSHSM := o_retSHSM || '【国】营业税改增值税应税服务类型较上期有变动，请核实！如有特殊情况，请填写审核说明！' || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000024'
                           || v_split;
                   end if;

                   --(if(@-1XXB->E3<>"",E16=@-1E16,true))|(t(2)="01")
                   --【国】消费税主要品目较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000027 TRUE
                   v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(16+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(16+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS || '(if(@-1XXB->E3<>"",E16=@-1E16,true))|(t(2)="01")'|| v_split;
                       --o_retSHSM := o_retSHSM || '【国】消费税主要品目较上期有变动，请核实！如有特殊情况，请填写审核说明！' || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000027'
                           || v_split;
                   end if;


                   --(if(@-1XXB->E19<>"",E19=@-1E19,true))|(t(2)="01")
                   --【国】企业所得税国、地税征收隶属关系较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000036 TRUE
                   v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(19+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(19+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS || '(if(@-1XXB->E19<>"",E19=@-1E19,true))|(t(2)="01")' || v_split;
                       --o_retSHSM := o_retSHSM ||'【国】企业所得税国、地税征收隶属关系较上期有变动，请核实！如有特殊情况，请填写审核说明！' || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000036'
                           || v_split;
                   end if;


                   --(if(@-1XXB->E3<>"",E22=@-1E22,true))|(t(2)="01")
                   --【国】营业税主要品目较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000041 TRUE
                   /*v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(22+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(22+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS || '(if(@-1XXB->E3<>"",E22=@-1E22,true))|(t(2)="01")'  || v_split;
                       --o_retSHSM := o_retSHSM || '【国】营业税主要品目较上期有变动，请核实！如有特殊情况，请填写审核说明！' || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000041'
                           || v_split;
                   end if;*/

                   --(if(@-1XXB->E3<>"",E31=@-1E31,true))|(t(2)="01")
                   --【国】监控级次较上期有变动，请核实！如有特殊情况，请填写审核说明！
                   --SH00000048 TRUE
                   v_temqyjbxx_char2 :=v_sb_zdsy_qyjbxx(31+v_qyjbxx_baseROW).col01;
                   v_temqyjbxx_char3 :=v_sb_zdsy_qyjbxx_sq(31+v_qyjbxx_baseROW).col01;
                   if v_temqyjbxx_char!=v_temqyjbxx_char2 then
                       --o_retSHGS := o_retSHGS || '(if(@-1XXB->E3<>"",E31=@-1E31,true))|(t(2)="01")'  || v_split;
                       --o_retSHSM := o_retSHSM || '【国】监控级次较上期有变动，请核实！如有特殊情况，请填写审核说明！'  || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000048'
                           || v_split;
                   end if;

              end if;
         end if;
      end if;



  END P_SB_BJJY_QYJBXX;




   ---------------------------------------------------------------------------------------------------
  --=================================================================================================
  ---------------------------以下方法为：调查问卷表---------------------------------------------
  --=================================================================================================
  ---------------------------------------------------------------------------------------------------
--调查问卷表校验
procedure P_SB_BJJY_JQDCWJ(
   i_server_date     IN VARCHAR2,
   i_nsrsbh   IN       VARCHAR2,--纳税人识别号
   i_sssq_q   IN       VARCHAR2,--所属时期起
   i_sssq_z   IN       VARCHAR2,--所属时期止
   o_retSHGS     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHSM     OUT      VARCHAR2,  --返回检查结果，如果有空字符或者字符串长度为0
   o_retSHBJ     OUT      CLOB  --返回检查结果，如果有空字符或者字符串长度为0
)
is

   type t_sb_zdsy_cwxx_rowtype is table of sb_zdsy_cwxx%rowtype index by binary_integer; --定义财务信息表类型
   type t_sb_zdsy_qyssxx_rowtype is table of sb_zdsy_qyssxx%rowtype index by binary_integer; --定义企业税收信息表类型
   type t_sb_zdsy_cpssb_rowtype is table of sb_zdsy_cpssb%rowtype index by binary_integer; --定义主要产品税收表类型
   type t_sb_zdsy_qyjbxx_rowtype is table of sb_zdsy_qyjbxx%rowtype index by binary_integer; --定义基本信息表类型
   type t_sb_zdsy_jqdcwj_rowtype is table of sb_zdsy_jqdcwj%rowtype index by binary_integer; --定义调查问卷表类型

   --增加变量
   v_sb_zdsy_qyjbxx_sq    t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量(上期数据)


   v_sb_zdsy_cwxx           t_sb_zdsy_cwxx_rowtype;--定义财务信息表变量
   v_sb_zdsy_qyssxx         t_sb_zdsy_qyssxx_rowtype;--定义企业税收信息表变量
   v_sb_zdsy_cpssb          t_sb_zdsy_cpssb_rowtype;--定义主要产品税收表变量
   v_sb_zdsy_qyjbxx         t_sb_zdsy_qyjbxx_rowtype;--定义基本信息表变量
   v_sb_zdsy_jqdcwj         t_sb_zdsy_jqdcwj_rowtype;--定义调查问卷表变量

   v_cur_yf                 VARCHAR2(11) := SUBSTR(i_server_date, 6, 2);--当前月份

   type t_jqdcwj_arr is table of number;
   v_jqdcwj_arr  t_jqdcwj_arr;

   v_wcfw INT DEFAULT 0;         --误差范围为1元, 2017.01.07不允许误差，设定误差为0
   v_temqyjbxx_char        varchar2(10);--企业基本信息字符串类型变量
   v_temqyjbxx_char2      varchar2(10);--企业基本信息字符串类型变量
   v_temqyjbxx_char3      varchar2(10);--企业基本信息字符串类型变量
   v_temcwxx1              NUMBER (16, 2);--财务信息表变量
   v_temcwxx2              NUMBER (16, 2);--财务信息表变量
   v_temcwxx3              NUMBER (16, 2);--财务信息表变量
   v_temcwxx4              NUMBER (16, 2);--财务信息表变量
   v_temcwxx5              NUMBER (16, 2);--财务信息表变量
   v_temcwxx              NUMBER (16, 2);--财务信息表变量
   v_temcwxx7              NUMBER (16, 2);--财务信息表变量
   v_temcwxx8              NUMBER (16, 2);--财务信息表变量
   v_temcwxx9              NUMBER (16, 2);--财务信息表变量
   v_temqyssxx             NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx1             NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx2            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx3            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx4            NUMBER (16, 2);--企业税收信息表变量
   v_temqyssxx5            NUMBER (16, 2);--企业税收信息表变量
   v_temcpssb             NUMBER (16, 2);--主要产品税收表变量
   v_temqyjbxx            NUMBER (16, 2);--基本信息表变量
   v_temjqdcwj            NUMBER (16, 2);--调查问卷表变量
   v_temjqdcwj1            NUMBER (16, 2);--调查问卷表变量
   v_temjqdcwj2            NUMBER (16, 2);--调查问卷表变量
   v_qyjbxx_baseROW           NUMBER;
   v_cwxx_baseROW        NUMBER;
   v_qyssxx_baseROW     NUMBER;
   v_jqdcwj_baseROW     NUMBER;
   v_split                   varchar2(10) := ',';
   v_flag varchar2(1) := 0;--用于标记是否保存过该公式
   v_gsflag varchar2(1) := 0;--用于计算公式时候的标记
BEGIN

v_qyjbxx_baseROW:=0;
v_qyssxx_baseROW:=-2;
v_cwxx_baseROW:=0;
v_jqdcwj_baseROW :=0;


   select * bulk collect into v_sb_zdsy_cwxx --给财务信息表变量赋值
     from sb_zdsy_cwxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyssxx --给企业税收信息表变量赋值
     from sb_zdsy_qyssxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_cpssb --给主要产品税收表变量赋值
     from sb_zdsy_cpssb t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_qyjbxx --给基本信息表变量赋值
     from sb_zdsy_qyjbxx t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;
   select * bulk collect into v_sb_zdsy_jqdcwj --给调查问卷表变量赋值
     from sb_zdsy_jqdcwj t
    where t.nsrsbh=i_nsrsbh
      and t.sssq_q=i_sssq_q
      and t.sssq_z=i_sssq_z
    order by hc;


/****
************************************************************************************
*************************以下校验位示例校验，请勿直接修改*****************************
************************************************************************************
****/

       /*================================================================================
       ============================  重点税源企业景气调查问卷  ==============================
      ================================================================================*/
      /*********************************+++++++++++季末报+++++++++****************************/
     if v_sb_zdsy_qyjbxx.count>0 and v_sb_zdsy_jqdcwj.count>0 then
          --if(B37>500000,B37<C37*10,true)|(XXB->E11="3")
          /*
             if(B37>500000,B37<C37*10,true)|(XXB->E11="3")
          */
          --【国】【地】请核实营业收入下季度预测！如有特殊情况，请填写审核说明！
          --表间（xxb） SH00000243 TRUE
          v_temjqdcwj := v_sb_zdsy_jqdcwj(v_jqdcwj_baseROW+37).col01;
          v_temjqdcwj2 := v_sb_zdsy_jqdcwj(v_jqdcwj_baseROW+37).col02;
          v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(v_qyjbxx_baseROW+11).col01;
          if v_temjqdcwj>500000 and v_temjqdcwj>v_temjqdcwj2*10 and v_temqyjbxx_char!='3' then
               --o_retSHGS := o_retSHGS || 'if(B37>500000,B37<C37*10,true)|(XXB->E11="3")' || v_split;
             --o_retSHSM := o_retSHSM || '【国】【地】请核实营业收入下季度预测！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000243'
                 || v_split;
          end if;

          --2、5、8、11月份为条件的校验
          if v_cur_yf in ('02','05','08','11') then
              v_temqyjbxx_char := v_sb_zdsy_qyjbxx(11+v_qyjbxx_baseROW).col01;
              --不是国内企业不需要校验
              if v_temqyjbxx_char!='3' then

                    --((if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B2:B4,B7:B9,B11:B12,B18:B19,B21:B22]<>null,true))|(XXB->E11="3"))
                    /*
                       (
                           (
                               if(
                                  (t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),
                                  [B2:B4,B7:B9,B11:B12,B18:B19,B21:B22]<>null,
                                  true
                                 )
                            )|(XXB->E11="3")
                       )
                    */
                    --【国】【地】2、5、8、11月份请填写《重点税源企业景气调查问卷》表！如有特殊情况，请填写审核说明！
                    --  SH00000238  TRUE
                    v_temjqdcwj :=v_sb_zdsy_jqdcwj(2).col03;
                    v_temjqdcwj2 :=0;
                    v_jqdcwj_arr := t_jqdcwj_arr(2,3,4,7,8,9,11,12,18,19,21,22);
                    for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                        if v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02=0 and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col03=0
                              and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col04=0 then
                             v_temjqdcwj2 := 1;
                             exit;
                        end if;
                    end loop;
                    if v_temjqdcwj2>0 then
                          --o_retSHGS := o_retSHGS || '((if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B2:B4,B7:B9,B11:B12,B18:B19,B21:B22]<>null,true))|(XXB->E11="3"))' || v_split;
                         --o_retSHSM := o_retSHSM || '【国】【地】2、5、8、11月份请填写《重点税源企业景气调查问卷》表！如有特殊情况，请填写审核说明！ ' || v_split;
                         o_retSHBJ := o_retSHBJ ||
                            'SH00000238'
                             || v_split;
                    end if;

                     --(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),(B15<>null)|(B16<>null),true))|(XXB->E11="3")
                     /*
                          (
                             if(
                                (t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),
                                (B15<>null)|(B16<>null),
                                true
                               )
                          )|(XXB->E11="3")
                    */
                    --【国】【地】2、5、8、11月，下季利润总额预计比本季(盈利企业填)或下季亏损额预计比本季(亏损企业填)不得同时为空！如有特殊情况，请填写审核说明！
                    --SH00000239  TRUE
                    v_jqdcwj_arr := t_jqdcwj_arr(15,16);
                    v_temjqdcwj :=0;
                    for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                        if v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02=0 and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col03=0
                              and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col04=0 then
                             v_temjqdcwj := v_temjqdcwj + 1;
                        end if;
                    end loop;
                    if v_temjqdcwj=2 then
                         --o_retSHGS := o_retSHGS || '(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),(B15<>null)|(B16<>null),true))|(XXB->E11="3")' || v_split;
                         --o_retSHSM := o_retSHSM ||  '【国】【地】2、5、8、11月，下季利润总额预计比本季(盈利企业填)或下季亏损额预计比本季(亏损企业填)不得同时为空！如有特殊情况，请填写审核说明！' || v_split;
                         o_retSHBJ := o_retSHBJ ||
                            'SH00000239'
                             || v_split;
                    end if;

                     /*************************************TODO*******************************************/
                    --(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),(((B15<>"0")|(B15<>null))&((B16="0")|(B16=null)))|(((B15="0")|(B15=null))&((B16<>"0")|(B16<>null))),true))|(XXB->E11="3")
                    /*
                       (
                           if(
                                (t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),
                                ( ((B15<>"0")|(B15<>null)) & ((B16="0")|(B16=null))--有一个false即可 )--false
                                    |
                                ( ((B15="0")|(B15=null)) & ((B16<>"0")|(B16<>null)) )--false,
                                true
                            )
                       )|(XXB->E11="3")
                    */
                    --【国】【地】2、5、8、11月必须填写下季利润总额预计比本季(盈利企业填)或 (亏损企业填)其中一项，不得同时填写！如有特殊情况，请填写审核说明！
                    --SH00000240  TRUE
                    v_jqdcwj_arr := t_jqdcwj_arr(15,16);
                    v_temjqdcwj :=0;
                    for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                           v_temjqdcwj := v_temjqdcwj+v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02+v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col03+
                                              v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col04;
                    end loop;
                    --选择了多个
                    if v_temjqdcwj>1then
                         --o_retSHGS := o_retSHGS || '(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),(((B15<>"0")|(B15<>null))&((B16="0")|(B16=null)))|(((B15="0")|(B15=null))&((B16<>"0")|(B16<>null))),true))|(XXB->E11="3")' || v_split;
                        --o_retSHSM := o_retSHSM || '【国】【地】2、5、8、11月必须填写下季利润总额预计比本季(盈利企业填)或 (亏损企业填)其中一项，不得同时填写！如有特殊情况，请填写审核说明！' || v_split;
                        o_retSHBJ := o_retSHBJ ||
                          'SH00000240'
                           || v_split;
                    end if;
              end if;--国内企业条件

              --if((((left(XXB->E4,2)>="06")&(left(XXB->E4,2)<="12"))|((left(XXB->E4,2)>="13")&(left(XXB->E4,2)<="43"))|((left(XXB->E4,2)>="44")&(left(XXB->E4,2)<="46")))&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),[B31:B34]<>null,true)|(t(2)="12")
              /*
                  if(
                         (
                             ( (left(XXB->E4,2)>="06")&(left(XXB->E4,2)<="12") )
                           |( (left(XXB->E4,2)>="13")&(left(XXB->E4,2)<="43") )
                           |( (left(XXB->E4,2)>="44")&(left(XXB->E4,2)<="46") )--todo
                        )&(
                           (t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")
                       ),
                       [B31:B34]<>null,
                       true
                   )|(t(2)="12")
              */
              --【国】【地】2、5、8、11月工业企业请填写《重点税源企业景气调查问卷》表第31栏至34栏！如有特殊情况，请填写审核说明！
              --SH00000242  TRUE
              v_temqyjbxx_char :=substr( v_sb_zdsy_qyjbxx(4+v_qyjbxx_baseROW).col01,1,2);
              v_jqdcwj_arr := t_jqdcwj_arr(31,32,33,34);
              v_temjqdcwj :=0;
              for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                  if v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02=0 and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col03=0
                        and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col04=0 then
                        v_temjqdcwj2 := 1;
                       exit;
                  end if;
              end loop;
              if (v_temqyjbxx_char>='06' and v_temqyjbxx_char<='12')
                  or (v_temqyjbxx_char>='13' and v_temqyjbxx_char<='43')
                  or (v_temqyjbxx_char>='44' and v_temqyjbxx_char<='46') then
                  if v_temjqdcwj2>0 and v_cur_yf!='12' then
                       --o_retSHGS := o_retSHGS || 'if((((left(XXB->E4,2)>="06")&(left(XXB->E4,2)<="12"))|((left(XXB->E4,2)>="13")&(left(XXB->E4,2)<="43"))|((left(XXB->E4,2)>="44")&(left(XXB->E4,2)<="46")))&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),[B31:B34]<>null,true)|(t(2)="12")'  || v_split;
                       --o_retSHSM := o_retSHSM || '【国】【地】2、5、8、11月工业企业请填写《重点税源企业景气调查问卷》表第31栏至34栏！如有特殊情况，请填写审核说明！'  || v_split;
                       o_retSHBJ := o_retSHBJ ||
                          'SH00000242'
                           || v_split;
                  end if;
              end if;


              --(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),([B37:B39]<>null)&([B37:B39]<>0)&([D37:D39]<>null)&([D37:D39]<>0),true))|(XXB->E11="3")|(left(XXB->E4,2)="70")
              /*
                   (
                        if(
                                 (t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),
                                 ([B37:B39]<>null)&([B37:B39]<>0)&([D37:D39]<>null)&([D37:D39]<>0),
                                 true
                           )
                    )|(XXB->E11="3")|(left(XXB->E4,2)="70")
              */
              --【国】【地】2、5、8、11月时必须填写预测数；如有特殊情况，请填写审核说明！
              --SH00000244  TRUE
              v_temqyjbxx_char :=v_sb_zdsy_qyjbxx(11+v_qyjbxx_baseROW).col01;
              v_temqyjbxx_char2 :=substr(v_sb_zdsy_qyjbxx(4+v_qyjbxx_baseROW).col01,1,2);
              if v_temqyjbxx_char!='3' and v_temqyjbxx_char2!='70' then
                   v_jqdcwj_arr := t_jqdcwj_arr(37,38,39);
                   v_temjqdcwj :=0;
                    for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                        if v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col01=0 or v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col03=0 then
                            v_temjqdcwj :=1;
                            exit;
                        end if;
                    end loop;
                    if v_temjqdcwj>0 then
                         --o_retSHGS := o_retSHGS || '(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),([B37:B39]<>null)&([B37:B39]<>0)&([D37:D39]<>null)&([D37:D39]<>0),true))|(XXB->E11="3")|(left(XXB->E4,2)="70")' || v_split;
                         --o_retSHSM := o_retSHSM ||'【国】【地】2、5、8、11月时必须填写预测数；如有特殊情况，请填写审核说明！'|| v_split;
                         o_retSHBJ := o_retSHBJ ||
                            'SH00000244'
                             || v_split;
                    end if;
              end if;
          end if;--2,5,8,11月条件

          --if((t(2)="11"),(if((XXB->E17<>"14")&(XXB->E17<>"24"),B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,0))<=E42,true)
          /*
              if(
                    (t(2)="11"),
                    (
                       if(
                            (XXB->E17<>"14")&(XXB->E17<>"24"),
                            B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,0
                         )
                     )<=E42 ,
                     true
               )
          */
          --【国】【地】2017年企业所得税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明！
          --SH00000256  TRUE
          /*if v_cur_yf='11' then
              v_temqyssxx :=0;
              v_temqyjbxx_char := v_sb_zdsy_qyjbxx(17+v_qyjbxx_baseROW).col01;
              if v_temqyjbxx_char!='14' and v_temqyjbxx_char!='24' then
                    v_temqyssxx :=v_sb_zdsy_qyssxx(108+v_qyssxx_baseROW).col02 +
                                    v_sb_zdsy_qyssxx(110+v_qyssxx_baseROW).col02 +
                                    v_sb_zdsy_qyssxx(112+v_qyssxx_baseROW).col02 +
                                    v_sb_zdsy_qyssxx(107+v_qyssxx_baseROW).col01 +
                                    v_sb_zdsy_qyssxx(156+v_qyssxx_baseROW).col02;
              end if;
              v_temjqdcwj :=  v_sb_zdsy_jqdcwj(42+v_qyjbxx_baseROW).col04;
              if v_temqyssxx > v_temjqdcwj then
                    --o_retSHGS := o_retSHGS || 'if((t(2)="11"),(if((XXB->E17<>"14")&(XXB->E17<>"24"),B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,0))<=E42,true)' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】2017年企业所得税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明！' || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000256'
                         || v_split;
              end if;
          end if;*/


         /*****************************************************************************************************/
         --取出不等式左边部分
         v_temqyjbxx_char := v_sb_zdsy_qyjbxx(17+v_qyjbxx_baseROW).col01;
         v_temqyssxx :=0;
         if v_temqyjbxx_char!='14' and v_temqyjbxx_char!='24' then
              v_temqyssxx := v_sb_zdsy_qyssxx(108+v_qyssxx_baseROW).col02+
                                 v_sb_zdsy_qyssxx(110+v_qyssxx_baseROW).col02+
                                 v_sb_zdsy_qyssxx(112+v_qyssxx_baseROW).col02+
                                 v_sb_zdsy_qyssxx(107+v_qyssxx_baseROW).col01+
                                 v_sb_zdsy_qyssxx(156+v_qyssxx_baseROW).col02;
         end if;
         v_jqdcwj_arr := t_jqdcwj_arr(79,82,83,154,92,95,155,147,157,129,131,135,137,140,142,144,146,149,150,151,152,153);
         for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
             v_temqyssxx :=v_temqyssxx +v_sb_zdsy_qyssxx(i+v_qyssxx_baseROW).col02;
         end loop;
         v_temqyssxx :=v_temqyssxx +
                           v_sb_zdsy_qyssxx(77+v_qyssxx_baseROW).col01+v_sb_zdsy_qyssxx(90+v_qyssxx_baseROW).col01+
                           v_sb_zdsy_qyssxx(82+v_qyssxx_baseROW).col01+v_sb_zdsy_qyssxx(154+v_qyssxx_baseROW).col01+
                           v_sb_zdsy_qyssxx(128+v_qyssxx_baseROW).col01+v_sb_zdsy_qyssxx(134+v_qyssxx_baseROW).col01+
                           v_sb_zdsy_qyssxx(136+v_qyssxx_baseROW).col01+v_sb_zdsy_qyssxx(139+v_qyssxx_baseROW).col01+
                           v_sb_zdsy_qyssxx(141+v_qyssxx_baseROW).col01+v_sb_zdsy_qyssxx(143+v_qyssxx_baseROW).col01+
                           v_sb_zdsy_qyssxx(145+v_qyssxx_baseROW).col01;
          --if((t(2)="11"),(if((XXB->E17<>"14")&(XXB->E17<>"24"),B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,0)+B1->E79+B1->D77-B1->E82+B1->E83+B1->E154+B1->E92+B1->D90+B1->E95+B1->E155+B1->E147+B1->E157+B1->E129+B1->E131+B1->E135+B1->E137+B1->E140+B1->E142+B1->E144+B1->E146+B1->E149+B1->E150+B1->E151+B1->E152+B1->E153+B1->D128+B1->D134+B1->D136+B1->D139+B1->D141+B1->D143+B1->D145)<=E39,true)
          /*
              if(
                  (t(2)="11"),
                  (
                      if(
                           (XXB->E17<>"14")&(XXB->E17<>"24"),
                           B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,
                           0
                       )+B1->E79+B1->D77-B1->E82+B1->E83+B1->E154+B1->E92
                        +B1->D90+B1->E95+B1->E155+B1->E147+B1->E157+B1->E129
                        +B1->E131+B1->E135+B1->E137+B1->E140+B1->E142+B1->E144
                        +B1->E146+B1->E149+B1->E150+B1->E151+B1->E152+B1->E153
                        +B1->D128+B1->D134+B1->D136+B1->D139+B1->D141+B1->D143
                        +B1->D145)<=E39,
                  true
                )
          */
          --【国】【地】2017年国内税收合计上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明
          --SH00000258  TRUE
          /*if v_cur_yf='11' then
               v_temjqdcwj := v_sb_zdsy_jqdcwj(39+v_jqdcwj_baseROW).col04;
               if v_temqyssxx>v_temjqdcwj then
                     --o_retSHGS := o_retSHGS ||  'if((t(2)="11"),(if((XXB->E17<>"14")&(XXB->E17<>"24"),B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,0)+B1->E79+B1->D77-B1->E82+B1->E83+B1->E154+B1->E92+B1->D90+B1->E95+B1->E155+B1->E147+B1->E157+B1->E129+B1->E131+B1->E135+B1->E137+B1->E140+B1->E142+B1->E144+B1->E146+B1->E149+B1->E150+B1->E151+B1->E152+B1->E153+B1->D128+B1->D134+B1->D136+B1->D139+B1->D141+B1->D143+B1->D145)<=E39,true)'  || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】2017年国内税收合计上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明  ！'  || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000258'
                         || v_split;
               end if;
          end if;*/


          --if(((t(2)="02")|(t(2)="05")|(t(2)="08")),(if((XXB->E17<>"14")&(XXB->E17<>"24"),B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,0)+B1->E79+B1->D77-B1->E82+B1->E83+B1->E154+B1->E92+B1->D90+B1->E95+B1->E155+B1->E147+B1->E157+B1->E129+B1->E131+B1->E135+B1->E137+B1->E140+B1->E142+B1->E144+B1->E146+B1->E149+B1->E150+B1->E151+B1->E152+B1->E153+B1->D128+B1->D134+B1->D136+B1->D139+B1->D141+B1->D143+B1->D145)<=B39,true)
         /*
             if(
                  ((t(2)="02")|(t(2)="05")|(t(2)="08")),
                  (
                      if(
                           (XXB->E17<>"14")&(XXB->E17<>"24"),
                           B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,
                           0
                        )+B1->E79+B1->D77-B1->E82+B1->E83+B1->E154+B1->E92
                         +B1->D90+B1->E95+B1->E155+B1->E147+B1->E157+B1->E129
                         +B1->E131+B1->E135+B1->E137+B1->E140+B1->E142+B1->E144
                         +B1->E146+B1->E149+B1->E150+B1->E151+B1->E152+B1->E153
                         +B1->D128+B1->D134+B1->D136+B1->D139+B1->D141+B1->D143
                         +B1->D145)<=D39,
                   true
               )
         */
         --【国】【地】国内税收合计应大于已缴税收之和！如有特殊情况，请填写审核说明！
         -- SH00000259  TRUE
         if v_cur_yf in ('02','05','08') then
               v_temjqdcwj := v_sb_zdsy_jqdcwj(39+v_jqdcwj_baseROW).col03;
               if v_temqyssxx>v_temjqdcwj then
                     --o_retSHGS := o_retSHGS ||  'if(((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),(if((XXB->E17<>"14")&(XXB->E17<>"24"),B1->E108+B1->E110+B1->E112+B1->D107+B1->E156,0)+B1->E79+B1->D77-B1->E82+B1->E83+B1->E154+B1->E92+B1->D90+B1->E95+B1->E155+B1->E147+B1->E157+B1->E129+B1->E131+B1->E135+B1->E137+B1->E140+B1->E142+B1->E144+B1->E146+B1->E149+B1->E150+B1->E151+B1->E152+B1->E153+B1->D128+B1->D134+B1->D136+B1->D139+B1->D141+B1->D143+B1->D145)<=B39,true)' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】国内税收合计应大于已缴税收之和！如有特殊情况，请填写审核说明！' || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000259'
                         || v_split;
               end if;
         end if;


         --if((XXB->E11<>"3")&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),((C37<>NULL)&(C37<>0))&((E37<>NULL)&(E37<>0))&((C38<>null)&(C38<>0))&((E38<>null)&(E38<>0)),TRUE)
         /*
                    if(
                            (XXB->E11<>"3")&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),
                            ((C37<>NULL)&(C37<>0))&((E37<>NULL)&(E37<>0))&((C38<>null)&(C38<>0))&((E38<>null)&(E38<>0)),
                            TRUE
                      )
         */
         --【国】【地】2、5、8、11月份独立核算企业应填报营业收入和利润总额，如有特殊情况，请填写审核说明！
         --SH00000274 TRUE
        /*v_temqyjbxx_char := v_sb_zdsy_qyjbxx(11+v_qyjbxx_baseROW).col01;
        v_jqdcwj_arr := t_jqdcwj_arr(37,38);
        v_temjqdcwj :=0;
        if v_cur_yf in ('02','05','08','11')  and v_temqyjbxx_char!='3'  then
            for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                if v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02=0 or v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col04=0 then
                    v_temjqdcwj :=1;
                    exit;
                end if;
            end loop;
            if v_temjqdcwj=1 then
                    --o_retSHGS := o_retSHGS ||  '(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B29:B30]<>null,true))|(t(2)="12")' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】2、5、8、11月份独立核算企业应填报营业收入和利润总额，如有特殊情况，请填写审核说明！'  || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000274'
                         || v_split;
            end if;
        end if;*/


         --(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B29:B30]<>null,true))|(t(2)="12")
         --【国】【地】2、5、8、11月份请填写《重点税源企业景气调查问卷》表！如有特殊情况，请填写审核说明！
         --SH00000241
          if v_cur_yf in ('02','05','08','11') then
              v_jqdcwj_arr := t_jqdcwj_arr(29,30);
              v_temjqdcwj :=0;
              for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                  if v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02=0 and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col03=0
                        and v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col04=0 then
                        v_temjqdcwj2 := 1;
                       exit;
                  end if;
              end loop;
              if v_temjqdcwj>0 then
                     --o_retSHGS := o_retSHGS ||'(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B29:B30]<>null,true))|(t(2)="12")' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】2、5、8、11月份请填写《重点税源企业景气调查问卷》表！如有特殊情况，请填写审核说明！' || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000241'
                         || v_split;
              end if;
          end if;

          --if((C39>5000)&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),([B37:B39]<=[C37:C39]*1.5)&([B37:B39]>=[C37:C39]/2),true)
          /*
              if(
                   (C39>5000)&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),
                   ([B37:B39]<=[C37:C39]*1.5)&([B37:B39]>=[C37:C39]/2),
                   true
               )
          */
          --【国】【地】请核实下季度预测数，如有特殊情况，请填写审核说明！
          --  SH00000253
          v_jqdcwj_arr :=t_jqdcwj_arr(37,38,39);
          v_temjqdcwj :=0;
          if v_cur_yf in ('02','05','08','11') and v_temjqdcwj>5000  then
               for i in v_jqdcwj_arr.first .. v_jqdcwj_arr.last loop
                     if  v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col01 >= v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02*1.5or
                         v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col01 < v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02/2 then
                        v_temjqdcwj :=1;
                        exit;
                     end if;
               end loop;
               if v_temjqdcwj>0 then
                     --o_retSHGS := o_retSHGS || 'if((C39>5000)&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),([B37:B39]<=[C37:C39]*1.5)&([B37:B39]>=[C37:C39]/2),true)  ' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】请核实下季度预测数，如有特殊情况，请填写审核说明！'  || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000253'
                         || v_split;
               end if;
          end if;


          if v_cur_yf ='11' then
               --if((t(2)="11"),(B1->E79+B1->D77-B1->E82+B1->E83+B1->E154)<=E40,true)
               --【国】【地】2017年增值税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明
               --SH00000254 TRUE
               v_temqyssxx := v_sb_zdsy_qyssxx(79+v_qyssxx_baseROW).col02+
                                  v_sb_zdsy_qyssxx(77+v_qyssxx_baseROW).col01+
                                  v_sb_zdsy_qyssxx(82+v_qyssxx_baseROW).col02+
                                  v_sb_zdsy_qyssxx(83+v_qyssxx_baseROW).col02+
                                  v_sb_zdsy_qyssxx(154+v_qyssxx_baseROW).col02;
               v_temjqdcwj := v_sb_zdsy_jqdcwj(40+v_jqdcwj_baseROW).col04;
               if v_temqyssxx>v_temjqdcwj then
                     --o_retSHGS := o_retSHGS || 'if((t(2)="11"),(B1->E79+B1->D77-B1->E82+B1->E83+B1->E154)<=E40,true)' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】2017年增值税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明！'  || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000254'
                         || v_split;
               end if;

               --if((t(2)="11"),(B1->E92+B1->D90+B1->E95+B1->E155)<=E41,true)
               --【国】【地】2017年消费税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明
               --SH00000255
               /*v_temqyssxx := v_sb_zdsy_qyssxx(92+v_qyssxx_baseROW).col02+
                                  v_sb_zdsy_qyssxx(90+v_qyssxx_baseROW).col01+
                                  v_sb_zdsy_qyssxx(95+v_qyssxx_baseROW).col02+
                                  v_sb_zdsy_qyssxx(155+v_qyssxx_baseROW).col02;
               v_temjqdcwj := v_sb_zdsy_jqdcwj(41+v_jqdcwj_baseROW).col04;
               if v_temqyssxx>v_temjqdcwj then
                     --o_retSHGS := o_retSHGS || 'if((t(2)="11"),(B1->E92+B1->D90+B1->E95+B1->E155)<=E41,true)'|| v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】2017年消费税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明！'  || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000255'
                         || v_split;
               end if;*/

               --if((t(2)="11"),(B1->E147+B1->E157)<=E43,true)
               --【国】【地】2017年个人所得税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明
               --SH00000257 TRUE
               /*v_temqyssxx := v_sb_zdsy_qyssxx(147+v_qyssxx_baseROW).col02+
                                  v_sb_zdsy_qyssxx(157+v_qyssxx_baseROW).col02;
               v_temjqdcwj := v_sb_zdsy_jqdcwj(43+v_jqdcwj_baseROW).col04;
               if v_temqyssxx>v_temjqdcwj then
                     --o_retSHGS := o_retSHGS ||'if((t(2)="11"),(B1->E147+B1->E157)<=E43,true)' || v_split;
                     --o_retSHSM := o_retSHSM || '【国】【地】2017年个人所得税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明！' || v_split;
                     o_retSHBJ := o_retSHBJ ||
                        'SH00000257'
                         || v_split;
               end if;*/
          end if;
      end if;--有数据条件
      
      
 /*********************************+++++++++++表内校验开始+++++++++****************************/ 
 /***
 (if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B29:B30]<>null,true))|(t(2)="12")
【国】【地】2、5、8、11月份请填写《重点税源企业景气调查问卷》表！如有特殊情况，请填写审核说明！
 SH00000241 TRUE      
 **/  
if v_sb_zdsy_jqdcwj.count>0 then
     v_gsflag := 0;
     v_flag := 0;
     if v_cur_yf in ('02','05','08','11') then
         v_gsflag := 1;
     end if;
     
     v_temjqdcwj := v_sb_zdsy_jqdcwj(29+v_jqdcwj_baseROW).col01;
     v_temjqdcwj1 := v_sb_zdsy_jqdcwj(30+v_jqdcwj_baseROW).col01;
     
     if substr(i_sssq_q,6 ,2 ) <> '12' then
       if v_gsflag = 1 then
         if v_temjqdcwj is null then
           if v_flag <> 1 then
            -- o_retSHGS := o_retSHGS || '(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B29:B30]<>null,true))|(t(2)="12")' || v_split;
            -- o_retSHSM := o_retSHSM || '【国】【地】2、5、8、11月份请填写《重点税源企业景气调查问卷》表！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000241'
                 || v_split;
             v_flag := 1;
           end if;
         end if;
       end if;
     end if;
     
     if v_cur_yf <> '12' then
       if v_gsflag = 1 then
         if v_temjqdcwj1 is null then
           if v_flag <> 1 then
            -- o_retSHGS := o_retSHGS || '(if((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11"),[B29:B30]<>null,true))|(t(2)="12")' || v_split;
            -- o_retSHSM := o_retSHSM || '【国】【地】2、5、8、11月份请填写《重点税源企业景气调查问卷》表！如有特殊情况，请填写审核说明！' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000241'
                 || v_split;
             v_flag := 1;
           end if;
         end if;
       end if;
     end if;


end if;


/***
 if((C39>5000)&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),([B37:B39]<=[C37:C39]*1.5)&([B37:B39]>=[C37:C39]/2),true)
【国】【地】请核实下季度预测数，如有特殊情况，请填写审核说明
 SH00000253 TRUE      
 **/  
if v_sb_zdsy_jqdcwj.count>0 then
     v_gsflag := 0;
     v_flag := 0;
     if substr(i_sssq_q,6 ,2 ) in ('02','05','08','11') then
         v_gsflag := 1;
     end if;
     
     v_temjqdcwj := v_sb_zdsy_jqdcwj(39+v_jqdcwj_baseROW).col02;
     
     
     if v_temjqdcwj > 5000 and v_gsflag = 1 then
      for i in 37 .. 39 loop
         v_temjqdcwj1 := v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col01;
         v_temjqdcwj2 := v_sb_zdsy_jqdcwj(i+v_jqdcwj_baseROW).col02;
     
         if v_temjqdcwj1 > v_temjqdcwj2 * 1.5 and v_temjqdcwj1 > v_temjqdcwj2 * 1.5 then
           if v_temjqdcwj is null then
             if v_flag <> 1 then
               --o_retSHGS := o_retSHGS ||'if((C39>5000)&((t(2)="02")|(t(2)="05")|(t(2)="08")|(t(2)="11")),([B37:B39]<=[C37:C39]*1.5)&([B37:B39]>=[C37:C39]/2),true)'|| v_split;
              --  o_retSHSM := o_retSHSM || '【国】【地】请核实下季度预测数，如有特殊情况，请填写审核说明' || v_split;
               o_retSHBJ := o_retSHBJ ||
                  'SH00000253'
                   || v_split;
               v_flag := 1;
             end if;
           end if;
         end if;
       end loop;
     end if;

end if;      
 

/***
 if((t(2)="11"),(B1->E79+B1->D77-B1->E82+B1->E83+B1->E154)<=E40,true)
【国】【地】2017年增值税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明
 SH00000254 TRUE      
 **/  
if v_sb_zdsy_jqdcwj.count>0 and v_sb_zdsy_qyssxx.count > 0 then
     v_temjqdcwj := v_sb_zdsy_jqdcwj(40+v_jqdcwj_baseROW).col02;
     
     v_temqyssxx1 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+79).col02,0);
     v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+77).col01,0);
     v_temqyssxx3 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+82).col02,0);
     v_temqyssxx4 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+83).col02,0);
     v_temqyssxx5 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+154).col02,0);
     
     if substr(i_sssq_q,6 ,2) = '11' then
       if v_temqyssxx1 + v_temqyssxx2 - v_temqyssxx3 - v_temqyssxx4 - v_temqyssxx5 > v_temjqdcwj then
            -- o_retSHGS := o_retSHGS ||'if((t(2)="11"),(B1->E79+B1->D77-B1->E82+B1->E83+B1->E154)<=E40,true)' || v_split;
            -- o_retSHSM := o_retSHSM || '【国】【地】2017年增值税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明'  || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000254'
                 || v_split;
       end if;
     end if;

end if; 



/***
 if((t(2)="11"),(B1->E92+B1->D90+B1->E95+B1->E155)<=E41,true)
【国】【地】2017年消费税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明
 SH00000255 TRUE      
 **/  
if v_sb_zdsy_jqdcwj.count>0 and v_sb_zdsy_qyssxx.count > 0 then
     v_temjqdcwj := v_sb_zdsy_jqdcwj(41+v_jqdcwj_baseROW).col02;
     
     v_temqyssxx1 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+92).col02,0);
     v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+90).col01,0);
     v_temqyssxx3 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+95).col02,0);
     v_temqyssxx4 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+155).col02,0);
     
     if substr(i_sssq_q,6 ,2) = '11' then
       if v_temqyssxx1 + v_temqyssxx2 + v_temqyssxx3 + v_temqyssxx4 > v_temjqdcwj then
            -- o_retSHGS := o_retSHGS || 'if((t(2)="11"),(B1->E92+B1->D90+B1->E95+B1->E155)<=E41,true)' || v_split;
            -- o_retSHSM := o_retSHSM || '【国】【地】2017年消费税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明' || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000255'
                 || v_split;
       end if;
     end if;

end if; 

/***
 if((t(2)="11"),(B1->E147+B1->E157)<=E43,true)
【国】【地】2017年个人所得税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明
 SH00000257 TRUE      
 **/  
/*if v_sb_zdsy_jqdcwj.count>0 and v_sb_zdsy_qyssxx.count > 0 then
     v_temjqdcwj := v_sb_zdsy_jqdcwj(43+v_jqdcwj_baseROW).col02;
     
     v_temqyssxx1 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+147).col02,0);
     v_temqyssxx2 :=nvl(v_sb_zdsy_qyssxx(v_qyssxx_baseROW+157).col02,0);
     
     if substr(i_sssq_q,6 ,2) = '11' then
       if v_temqyssxx1 + v_temqyssxx2 > v_temjqdcwj then
            -- o_retSHGS := o_retSHGS ||'if((t(2)="11"),(B1->E147+B1->E157)<=E43,true)' || v_split;
            -- o_retSHSM := o_retSHSM || '【国】【地】2017年个人所得税上年同期数应大于等于前十一月累计数加上11月份应纳税额，如有特殊情况，请填写审核说明'  || v_split;
             o_retSHBJ := o_retSHBJ ||
                'SH00000257'
                 || v_split;
       end if;
     end if;

end if; */

/*********************************+++++++++++表内校验结束+++++++++****************************/ 


  END P_SB_BJJY_JQDCWJ;





end PKG_SB_ZDSY_BJJY;




/
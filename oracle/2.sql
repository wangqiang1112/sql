create or replace package PKG_SB_ZDSY_SBB_TXT is

  /*
    Author  : wyq
    Created : 2017-02-28
    Purpose :�����ص�˰Դ��ѯͳ�ƴ�������걨��txt��׼�����ļ�


   1���޸�ʱ�䣺20170915
      �޸��ˣ�wyq
      �޸����⣺1)�淶���뼰�������������ʽ

   2���޸�ʱ�䣺20170921
      �޸��ˣ�wyq
      �޸����⣺1)��˱�����sssq_z�Ĳ�ѯ����

   3���޸�ʱ�䣺20170925
      �޸��ˣ�wyq
      �޸����⣺1)�淶�Զ����������ɾ�����õı�������

   4���޸�ʱ�䣺20170927
      �޸��ˣ�wyq
      �޸����⣺1)Ϊ��trasϵͳ�е���ģ�壬�޸Ĳ����ֶ����Ƽ��д���Ϣ
                2)����ģ������ƴ�Ӿ��������txt��ʽ

   5���޸�ʱ�䣺20171012
      �޸��ˣ�wyq
      �޸����⣺1)�޸���Ԫ��������

   6���޸�ʱ�䣺20171023
      �޸��ˣ�wyq
      �޸����⣺1)�޸Ĳ�Ʒ���ͷƴ��ʱ��������

   7���޸�ʱ�䣺20171027
      �޸��ˣ�wyq
      �޸����⣺1)�޸���˱���ģ�弰�걨�����ƣ����ڵ���trasϵͳ

   8���޸�ʱ�䣺20171031
      �޸��ˣ�wyq
      �޸����⣺1)������˰�������޸Ĳ�Ʒ��11-18�������ݿ�ԭ���ݵ��룬���ٳ���10000

   9���޸�ʱ�䣺20171221
      �޸��ˣ�wyq
      �޸����⣺1)�޸ľ�������������ģ�壬������������ϰ벿�ִ��ڿյ�ѡ��ʱ�����뵥�������ݻ��ҵ�����

   10���޸�ʱ�䣺20171222
      �޸��ˣ�wyq
      �޸����⣺1)����˱��ѯ�е�yxbz����ɾ�������������Ϣ���в�����˹�ʽ���ܵ���

   11���޸�ʱ�䣺20180131
      �޸��ˣ�wyq
      �޸����⣺1)�޸�F_ZDSY_SHMC_ZS�����е�djxh������Ϊ�����Ϣ���ѯ���shnd��ѯ�ֶ�

   12���޸�ʱ�䣺20180206
      �޸��ˣ�wyq
      �޸����⣺1)˰�ձ���2�·�ʱ�ۼ�ֵ�޸�Ϊ�͵���ֵ��ͬ
                2)������������ɾ����Ԫת��

   13���޸�ʱ�䣺20180208
      �޸��ˣ�wyq
      �޸����⣺1)˰�ձ����ָ���дα��������ɱ༭ʱ�����ļ��ÿգ��ۼ���������ʾ���ݵ��ж�
                2)��Ʒ������������µ�����Ԫ��
                3)�޸Ĳ�Ʒ���������ݵ��뵥����ʱ���������
                4)��˰�ձ�166 167�ж���ҵ�ÿյ����Ʒſ�

  14���޸�ʱ�䣺20180302
      �޸��ˣ�wyq
      ����1)Ϊ��ѯ�û��б������û��걨״̬
            2)���ݼ�������Ż���ѯ�û��Ǽ���ţ�����Ǽ����ƴ�ӹ�������
  */

   TYPE v_sb_zdsy_djxhs_cols IS RECORD(
      djxh  SB_ZDSY_NSRRDQCXX.djxh%TYPE);
    TYPE t_sb_zdsy_djxhs_rowtype IS TABLE OF v_sb_zdsy_djxhs_cols;



  procedure P_SB_ZDSY_SBBZL(i_ywdm     in varchar2,
                            i_splittag in number,
                            i_djxhs    in varchar2,
                            i_sssq_q   in varchar2,
                            i_sssq_z   in varchar2,
                            i_jbdms   in varchar2,
                            i_sbjgdm   in varchar2,
                            o_txt     out CLOB);
  /*procedure P_SB_EXPORT_QYSSXX(
       i_djxhs   IN       VARCHAR2,--��˰��ʶ���
       v_nsrmcs   IN       VARCHAR2,--��˰������
       v_splittag   IN       number,--�ָ���
       v_sssq_q   IN       VARCHAR2,--����ʱ����
       v_sssq_z   IN       VARCHAR2,--����ʱ��ֹ
       ret_txt     OUT      CLOB  --����ƴ�ӽ����
  );  */

  procedure P_SB_EXPORT_QYSSXX(v_djxhstr_qyssxx_arr    IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                               i_splittag IN number, --�ָ���
                               i_sssq_q   IN VARCHAR2, --����ʱ����
                               i_sssq_z   IN VARCHAR2, --����ʱ��ֹ
                               o_ret_txt    OUT CLOB --����ƴ�ӽ����
                               );

  procedure P_SB_EXPORT_CWBB(v_djxhstr_cwxx_arr    IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                             i_splittag IN number, --�ָ���
                             i_sssq_q   IN VARCHAR2, --����ʱ����
                             i_sssq_z   IN VARCHAR2, --����ʱ��ֹ
                             o_ret_txt    OUT CLOB --����ƴ�ӽ����
                             );

  procedure P_SB_EXPORT_JQDCWJ(v_djxhstr_jqdcwj_arr    IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                               i_splittag IN number, --�ָ���
                               i_sssq_q   IN VARCHAR2, --����ʱ����
                               i_sssq_z   IN VARCHAR2, --����ʱ��ֹ
                               o_ret_txt    OUT CLOB --����ƴ�ӽ����
                               );

  procedure P_SB_EXPORT_QYJBXX(v_djxhstr_qyjbxx_arr    IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                               i_splittag IN number, --�ָ���
                               i_sssq_q   IN VARCHAR2, --����ʱ����
                               i_sssq_z   IN VARCHAR2, --����ʱ��ֹ
                               o_ret_txt    OUT CLOB --����ƴ�ӽ����
                               );

  procedure P_SB_EXPORT_CPSSB(v_djxhstr_cpssb_arr    IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                              i_splittag IN number, --�ָ���
                              i_sssq_q   IN VARCHAR2, --����ʱ����
                              i_sssq_z   IN VARCHAR2, --����ʱ��ֹ
                              o_ret_txt    OUT CLOB --����ƴ�ӽ����
                              );

  procedure P_SB_EXPORT_SHB(v_djxhstr_shb_arr    IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                            i_splittag IN number, --�ָ���
                            i_sssq_q   IN VARCHAR2, --����ʱ����
                            i_sssq_z   IN VARCHAR2, --����ʱ��ֹ
                            o_ret_txt    OUT CLOB --����ƴ�ӽ����
                            );


end PKG_SB_ZDSY_SBB_TXT;
/

create or replace package body PKG_SB_ZDSY_SBB_TXT is

  v_sb_zdsy_djxhs t_sb_zdsy_djxhs_rowtype := t_sb_zdsy_djxhs_rowtype();

  procedure P_SB_ZDSY_SBBZL(i_ywdm     in varchar2,
                            i_splittag in number,
                            i_djxhs    in varchar2,
                            i_sssq_q   in varchar2,
                            i_sssq_z   in varchar2,
                            i_jbdms    in varchar2,
                            i_sbjgdm   in varchar2,
                            o_txt      out CLOB) is


    v_djxhstr_arr TYPE_SPLIT := split_str(i_djxhs, ',');
    v_jbdm_str    varchar2(200);
    v_year_str    varchar2(10) := 'yyyy';
    v_sql         varchar2(2000);

  begin

    if i_jbdms is not null or i_jbdms != '' then
      /*if v_jbdm_str = 1 then
         v_jbdm_str := '';
       elsif v_jbdm_str = -1 then
         v_jbdm_str := ' and jg.sbjg_dm is null';
       else
         v_jbdm_str := ' and jg.sbjg_dm = :i_sbjgdm';
       end if;
       v_sql := 'select qylb.djxh
         from
        (SELECT qy.*, 99 jbdm, 0 isparent, sbjg_dm, gt.zzjg_mc swjg_mc
          FROM (select decode(p.shxydm, null, p.nsrsbh, p.shxydm) swjg_dm,
                       p.djxh djxh,
                       p.ZGSWSKFJ_DM sjswjg_dm,
                       p.nsrmc nsrmc,
                       decode(p.shxydm, null, p.nsrsbh, p.shxydm) nsrsbh,
                       p.ZGSWSKFJ_DM,
                       (select zzjg_mc
                          from jspt.pt_dm_zzjg w0
                         where w0.zzjg_dm = p.ZGSWSKFJ_DM) ZGSWSKFJ_MC,
                       (select zzjg_mc
                          from jspt.pt_dm_zzjg w0
                         where w0.zzjg_dm = p.ZGSWJ_DM) ZGSWJ_MC,
                       w.sj_zzjg_dm sjdm,
                       w.jbdm jbdm_1
                  FROM SB_ZDSY_NSRRDQCXX p, jspt.pt_dm_zzjg w
                 where w.zzjg_dm = p.ZGSWSKFJ_DM
                   AND p.SHND = to_char(sysdate, :v_year_str)) qy
          LEFT JOIN sb_sbjg jg
            ON qy.djxh = jg.djxh
           AND jg.sssq_q = :i_sssq_q
           AND jg.sssq_z = :i_sssq_z
          LEFT JOIN jspt.pt_dm_zzjg gt
            ON qy.ZGSWSKFJ_DM = gt.zzjg_dm
         WHERE regexp_like(qy.jbdm_1, :i_jbdms) :v_jbdm_str) qylb';
      execute immediate v_sql bulk collect into v_sb_zdsy_djxhs using v_year_str,i_sssq_q,i_sssq_z,i_jbdms,v_jbdm_str;*/
      select qylb.djxh
        bulk collect
        into v_sb_zdsy_djxhs
        from (SELECT qy.*,
                     '99' jbdm,
                     'false' isparent,
                     sbjg_dm,
                     gt.zzjg_mc swjg_mc
                FROM (select decode(p.shxydm, null, p.nsrsbh, p.shxydm) swjg_dm,
                             p.djxh djxh,
                             p.ZGSWSKFJ_DM sjswjg_dm,
                             p.nsrmc nsrmc,
                             decode(p.shxydm, null, p.nsrsbh, p.shxydm) nsrsbh,
                             p.ZGSWSKFJ_DM,
                             (select zzjg_mc
                                from jspt.pt_dm_zzjg w0
                               where w0.zzjg_dm = p.ZGSWSKFJ_DM) ZGSWSKFJ_MC,
                             (select zzjg_mc
                                from jspt.pt_dm_zzjg w0
                               where w0.zzjg_dm = p.ZGSWJ_DM) ZGSWJ_MC,
                             w.sj_zzjg_dm sjdm,
                             w.jbdm jbdm_1
                        FROM SB_ZDSY_NSRRDQCXX p, jspt.pt_dm_zzjg w
                       where w.zzjg_dm = p.ZGSWSKFJ_DM
                         AND p.SHND = to_char(sysdate, 'yyyy')) qy
                LEFT JOIN sb_sbjg jg
                  ON qy.djxh = jg.djxh
                 AND jg.sssq_q = i_sssq_q
                 AND jg.sssq_z = i_sssq_z
                LEFT JOIN jspt.pt_dm_zzjg gt
                  ON qy.ZGSWSKFJ_DM = gt.zzjg_dm
               WHERE regexp_like(qy.jbdm_1, i_jbdms)
                 and F_GET_SBJG_TXT(i_sbjgdm, jg.sbjg_dm) = 'T') qylb;

    else
      /* v_sb_zdsy_djxhs.extend(v_djxhstr_arr.count);
       for i in 1 .. v_djxhstr_arr.count loop
         v_sb_zdsy_djxh.djxh := v_djxhstr_arr(i);
        v_sb_zdsy_djxhs(i) := v_sb_zdsy_djxh;
      end loop;*/
      --��ת��
      SELECT REGEXP_SUBSTR(i_djxhs, '[^,]+', 1, LEVEL, 'i')
        bulk collect
        into v_sb_zdsy_djxhs
        FROM DUAL
      CONNECT BY LEVEL <=
                 LENGTH(i_djxhs) - LENGTH(REGEXP_REPLACE(i_djxhs, ',', '')) + 1;

    end if;

    case i_ywdm
      when 'B1' then
        P_SB_EXPORT_QYSSXX(v_sb_zdsy_djxhs,
                           i_splittag,
                           i_sssq_q,
                           i_sssq_z,
                           o_txt);
      when 'B3' then
        P_SB_EXPORT_CWBB(v_sb_zdsy_djxhs,
                         i_splittag,
                         i_sssq_q,
                         i_sssq_z,
                         o_txt);
      when 'B4' then
        P_SB_EXPORT_JQDCWJ(v_sb_zdsy_djxhs,
                           i_splittag,
                           i_sssq_q,
                           i_sssq_z,
                           o_txt);
      when 'XXB' then
        P_SB_EXPORT_QYJBXX(v_sb_zdsy_djxhs,
                           i_splittag,
                           i_sssq_q,
                           i_sssq_z,
                           o_txt);
      when 'B2' then
        P_SB_EXPORT_CPSSB(v_sb_zdsy_djxhs,
                          i_splittag,
                          i_sssq_q,
                          i_sssq_z,
                          o_txt);
      else
        P_SB_EXPORT_SHB(v_sb_zdsy_djxhs,
                        i_splittag,
                        i_sssq_q,
                        i_sssq_z,
                        o_txt);
    end case;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      o_txt := '**Error line:' || dbms_utility.format_error_backtrace() ||
               '   ' || SQLCODE || '   ' || SQLERRM;
      /*dbms_output.put_line('**Error line:' ||
                           dbms_utility.format_error_backtrace());
      dbms_output.put_line('**Error code:' || SQLCODE);
      dbms_output.put_line('**Error info:' || SQLERRM);
      return;*/
  END P_SB_ZDSY_SBBZL;

  procedure P_SB_EXPORT_QYSSXX(v_djxhstr_qyssxx_arr IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                               i_splittag           IN number, --�ָ���
                               i_sssq_q             IN VARCHAR2, --����ʱ����
                               i_sssq_z             IN VARCHAR2, --����ʱ��ֹ
                               o_ret_txt            OUT CLOB --����ƴ�ӽ����
                               ) is

    type t_sb_zdsy_qyssxx_rowtype is table of sb_zdsy_qyssxx%rowtype index by binary_integer; --������ҵ˰����Ϣ������
    type t_colstr_arr is table of varchar2(100);
    type t_colnum_arr is table of number(10, 0); --������Ԫ������
    type t_row_isNull_arr is table of number(10, 0); --��������Ҫ�ÿյ���

    v_sb_zdsy_qyssxx    t_sb_zdsy_qyssxx_rowtype; --������ҵ˰����Ϣ�����
    v_colstr_qyssxx_arr t_colstr_arr := t_colstr_arr('D', 'E', 'F', 'G');
    v_wyh_qyssxx_arr    t_colnum_arr := t_colnum_arr(166,
                                                     167,
                                                     168,
                                                     169,
                                                     178);
    v_isNull_qyssxx_arr t_row_isNull_arr := t_row_isNull_arr(174,
                                                             175,
                                                             176,
                                                             177,
                                                             178,
                                                             179,
                                                             180,
                                                             181,
                                                             182,
                                                             183,
                                                             184,
                                                             185,
                                                             186,
                                                             187,
                                                             188,
                                                             189,
                                                             190);
    --v_djxhstr_qyssxx_arr TYPE_SPLIT := split_str(i_djxhs, ',');

    --v_isnull_str       varchar2(200) := '164,165,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190';
    v_br        varchar2(10) := '##'; --�����ɵ�txt���滻Ϊ���з�
    v_bbq       varchar2(20); --�걨��ı�����
    v_split1    varchar2(10) := ','; --�������ص�txt�зָ����ݵı��
    v_tableTag  varchar2(10) := 'B1_'; --�걨����
    v_str       varchar2(2000); --ƴ��txt����ʱ����
    v_sh_zs     varchar2(100); --˰��չʾ����
    v_mc_zs     varchar2(100); --����չʾ����
    v_yf        varchar2(20); --�·�
    v_iscontant varchar2(20) := 'N'; --�д��Ƿ������������
  BEGIN

    if i_splittag = 1 then
      v_split1 := chr(9);
    end if;

    dbms_lob.createtemporary(o_ret_txt, true);
    --ƴ�ӱ�ͷ��Ϣ
    v_str := 'BBQ' || v_split1 || 'ID' || v_split1 || 'NAME';
    dbms_lob.append(o_ret_txt, v_str);

    for i in 1 .. v_djxhstr_qyssxx_arr.count loop
      select *
        bulk collect
        into v_sb_zdsy_qyssxx --����ҵ˰����Ϣ�������ֵ
        from sb_zdsy_qyssxx t
       where t.djxh = v_djxhstr_qyssxx_arr(i).djxh
         and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z;

      if v_sb_zdsy_qyssxx.count > 0 then
        exit;
      end if;
    end loop;

    for i in 1 .. v_sb_zdsy_qyssxx.count loop
      for j in 1 .. v_colstr_qyssxx_arr.count loop
        v_str := v_split1 || v_tableTag || v_colstr_qyssxx_arr(j) ||
                 to_char(i + 2);
        dbms_lob.append(o_ret_txt, v_str);
      end loop;
    end loop;

    dbms_lob.append(o_ret_txt, v_br);

    --ƴ��ÿ�е�������Ϣ
    v_bbq := substr(i_sssq_q, 0, 4) || substr(i_sssq_q, 6, 2);
    for i in 1 .. v_djxhstr_qyssxx_arr.count loop
      select F_ZDSY_SHMC_ZS(v_djxhstr_qyssxx_arr(i).djxh, 'SH')
        into v_sh_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_qyssxx_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      select F_ZDSY_SHMC_ZS(v_djxhstr_qyssxx_arr(i).djxh, 'MC')
        into v_mc_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_qyssxx_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      v_str := v_bbq || v_split1 || v_sh_zs || v_split1 || v_mc_zs;

      dbms_lob.append(o_ret_txt, v_str);

      select *
        bulk collect
        into v_sb_zdsy_qyssxx --����ҵ˰����Ϣ�������ֵ
        from sb_zdsy_qyssxx t
       where t.djxh = v_djxhstr_qyssxx_arr(i).djxh
         and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z
       order by t.hc;

      v_yf := substr(i_sssq_q, 6, 2);
      for i in 1 .. v_sb_zdsy_qyssxx.count loop
        if v_yf = '01' then
          if i in (164, 165, 166, 167, 176) then
            v_iscontant := 'N';
            for j in 1 .. v_isNull_qyssxx_arr.count loop
              if i = v_isNull_qyssxx_arr(j) then
                v_iscontant := 'Y';
                exit;
              end if;
            end loop;
            if v_iscontant = 'Y' then
              v_str := v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL02 || v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL04;
            else
              v_str := v_split1 || v_sb_zdsy_qyssxx(i).COL01 || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL01 || v_split1 || v_sb_zdsy_qyssxx(i).COL03 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL04;
            end if;
            dbms_lob.append(o_ret_txt, v_str);
          else
            v_iscontant := 'N';
            for j in 1 .. v_isNull_qyssxx_arr.count loop
              if i = v_isNull_qyssxx_arr(j) then
                v_iscontant := 'Y';
                exit;
              end if;
            end loop;
            if v_iscontant = 'Y' then
              v_str := v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL02 / 10000 || v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL04 / 10000;
            else
              v_str := v_split1 || v_sb_zdsy_qyssxx(i).COL01 / 10000 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL01 / 10000 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL03 / 10000 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL04 / 10000;
            end if;
            dbms_lob.append(o_ret_txt, v_str);
          end if;
        else
          if i in (164, 165, 166, 167, 176) then
            v_iscontant := 'N';
            for j in 1 .. v_isNull_qyssxx_arr.count loop
              if i = v_isNull_qyssxx_arr(j) then
                v_iscontant := 'Y';
                exit;
              end if;
            end loop;
            if v_iscontant = 'Y' then
              v_str := v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL02 || v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL04;
            else
              v_str := v_split1 || v_sb_zdsy_qyssxx(i).COL01 || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL02 || v_split1 || v_sb_zdsy_qyssxx(i).COL03 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL04;
            end if;
            dbms_lob.append(o_ret_txt, v_str);

          else
            v_iscontant := 'N';
            for j in 1 .. v_isNull_qyssxx_arr.count loop
              if i = v_isNull_qyssxx_arr(j) then
                v_iscontant := 'Y';
                exit;
              end if;
            end loop;
            if v_iscontant = 'Y' then
              v_str := v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL02 / 10000 || v_split1 || '' || v_split1 || v_sb_zdsy_qyssxx(i)
                      .COL04 / 10000;
            else
              v_str := v_split1 || v_sb_zdsy_qyssxx(i).COL01 / 10000 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL02 / 10000 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL03 / 10000 ||
                       v_split1 || v_sb_zdsy_qyssxx(i).COL04 / 10000;
            end if;
            dbms_lob.append(o_ret_txt, v_str);
          end if;
        end if;
        --dbms_lob.append(o_ret_txt, v_str);
      end loop;

      dbms_lob.append(o_ret_txt, v_br);

    end loop;

  END P_SB_EXPORT_QYSSXX;

  procedure P_SB_EXPORT_CWBB(v_djxhstr_cwxx_arr IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                             i_splittag         IN number, --�ָ���
                             i_sssq_q           IN VARCHAR2, --����ʱ����
                             i_sssq_z           IN VARCHAR2, --����ʱ��ֹ
                             o_ret_txt          OUT CLOB --����ƴ�ӽ����
                             ) is

    type t_sb_zdsy_cwxx_rowtype is table of sb_zdsy_cwxx%rowtype index by binary_integer; --������ҵ������Ϣ������
    type t_colstr_arr is table of varchar2(100);

    v_sb_zdsy_cwxx    t_sb_zdsy_cwxx_rowtype; --���������Ϣ�����
    v_colstr_cwxx_arr t_colstr_arr := t_colstr_arr('C',
                                                   'D',
                                                   'G',
                                                   'H',
                                                   'I',
                                                   'J');
    --v_djxhstr_cwxx_arr TYPE_SPLIT := split_str(i_djxhs, ',');

    v_br       varchar2(10) := '##'; --�����ɵ�txt���滻Ϊ���з�
    v_bbq      varchar2(20); --�걨��ı�����
    v_split1   varchar2(10) := ','; --�������ص�txt�зָ����ݵı��
    v_tableTag varchar2(10) := 'B3_'; --�걨����
    v_str      varchar2(2000); --ƴ��txt����ʱ����
    v_sh_zs    varchar2(100); --˰��չʾ����
    v_mc_zs    varchar2(100); --����չʾ����
  BEGIN

    if i_splittag = 1 then
      v_split1 := chr(9);
    end if;

    dbms_lob.createtemporary(o_ret_txt, true);
    --ƴ�ӱ�ͷ��Ϣ
    v_str := 'BBQ' || v_split1 || 'ID' || v_split1 || 'NAME';
    dbms_lob.append(o_ret_txt, v_str);

    for i in 1 .. v_djxhstr_cwxx_arr.count loop
      select *
        bulk collect
        into v_sb_zdsy_cwxx --����ҵ������Ϣ�������ֵ
        from sb_zdsy_cwxx t
       where t.djxh = v_djxhstr_cwxx_arr(i).djxh
            --and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z;

      if v_sb_zdsy_cwxx.count > 0 then
        exit;
      end if;
    end loop;

    for i in 1 .. v_sb_zdsy_cwxx.count loop
      for j in 1 .. v_colstr_cwxx_arr.count loop
        v_str := v_split1 || v_tableTag || v_colstr_cwxx_arr(j) ||
                 to_char(i + 2);
        dbms_lob.append(o_ret_txt, v_str);
      end loop;
    end loop;

    dbms_lob.append(o_ret_txt, v_br);

    --ƴ��ÿ�е�������Ϣ
    v_bbq := substr(i_sssq_q, 0, 4) || substr(i_sssq_q, 6, 2);
    for i in 1 .. v_djxhstr_cwxx_arr.count loop
      select F_ZDSY_SHMC_ZS(v_djxhstr_cwxx_arr(i).djxh, 'SH')
        into v_sh_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_cwxx_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      select F_ZDSY_SHMC_ZS(v_djxhstr_cwxx_arr(i).djxh, 'MC')
        into v_mc_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_cwxx_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      v_str := v_bbq || v_split1 || v_sh_zs || v_split1 || v_mc_zs;

      dbms_lob.append(o_ret_txt, v_str);

      select *
        bulk collect
        into v_sb_zdsy_cwxx --����ҵ˰����Ϣ�������ֵ
        from sb_zdsy_cwxx t
       where t.djxh = v_djxhstr_cwxx_arr(i).djxh
            --and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z
       order by t.hc;

      for i in 1 .. v_sb_zdsy_cwxx.count loop
        v_str := v_split1 || v_sb_zdsy_cwxx(i).COL01 / 10000 || v_split1 || v_sb_zdsy_cwxx(i)
                .COL02 / 10000 || v_split1 || v_sb_zdsy_cwxx(i)
                .COL03 / 10000 || v_split1 || v_sb_zdsy_cwxx(i)
                .COL04 / 10000 || v_split1 || v_sb_zdsy_cwxx(i)
                .COL05 / 10000 || v_split1 || v_sb_zdsy_cwxx(i)
                .COL06 / 10000;
        dbms_lob.append(o_ret_txt, v_str);
      end loop;

      dbms_lob.append(o_ret_txt, v_br);

    end loop;

  END P_SB_EXPORT_CWBB;

  procedure P_SB_EXPORT_JQDCWJ(v_djxhstr_jqdcwj_arr IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                               i_splittag           IN number, --�ָ���
                               i_sssq_q             IN VARCHAR2, --����ʱ����
                               i_sssq_z             IN VARCHAR2, --����ʱ��ֹ
                               o_ret_txt            OUT CLOB --����ƴ�ӽ����
                               ) is

    type t_sb_zdsy_jqdcwj_rowtype is table of sb_zdsy_jqdcwj%rowtype index by binary_integer; --������ҵ������Ϣ������
    type t_colstr_arr is table of varchar2(100);

    v_sb_zdsy_jqdcwj    t_sb_zdsy_jqdcwj_rowtype; --������ҵ������Ϣ�����
    v_colstr_jqdcwj_arr t_colstr_arr := t_colstr_arr('B', 'C', 'D', 'E');
    --v_djxhstr_jqdcwj_arr TYPE_SPLIT := split_str(i_djxhs, ',');

    v_br       varchar2(10) := '##'; --�����ɵ�txt���滻Ϊ���з�
    v_bbq      varchar2(20); --�걨��ı�����
    v_split1   varchar2(10) := ','; --�������ص�txt�зָ����ݵı��
    v_tableTag varchar2(10) := 'B4_'; --�걨����
    v_str      varchar2(2000); --ƴ��txt����ʱ����
    v_sh_zs    varchar2(100); --˰��չʾ����
    v_mc_zs    varchar2(100); --����չʾ����

  BEGIN

    if i_splittag = 1 then
      v_split1 := chr(9);
    end if;

    dbms_lob.createtemporary(o_ret_txt, true);
    --ƴ�ӱ�ͷ��Ϣ
    v_str := 'BBQ' || v_split1 || 'ID' || v_split1 || 'NAME';
    dbms_lob.append(o_ret_txt, v_str);

    for i in 1 .. v_djxhstr_jqdcwj_arr.count loop
      select *
        bulk collect
        into v_sb_zdsy_jqdcwj --����ҵ�����������ֵ
        from sb_zdsy_jqdcwj t
       where t.djxh = v_djxhstr_jqdcwj_arr(i).djxh
            --and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z;

      if v_sb_zdsy_jqdcwj.count > 0 then
        exit;
      end if;
    end loop;

    for i in 1 .. v_sb_zdsy_jqdcwj.count + 1 loop

      v_str := v_split1 || v_tableTag || 'B';

      if i not in (1, 5, 6, 10, 17, 20, 23, 28, 35, 36) and i < 37 then
        v_str := v_split1 || v_tableTag || 'B' || to_char(i);
        dbms_lob.append(o_ret_txt, v_str);

      end if;

      if i >= 37 then
        for j in 1 .. v_colstr_jqdcwj_arr.count loop
          v_str := v_split1 || v_tableTag || v_colstr_jqdcwj_arr(j) ||
                   to_char(i);
          dbms_lob.append(o_ret_txt, v_str);
        end loop;
      end if;

    end loop;

    dbms_lob.append(o_ret_txt, v_br);

    --ƴ��ÿ�е�������Ϣ
    v_bbq := substr(i_sssq_q, 0, 4) || substr(i_sssq_q, 6, 2);
    for i in 1 .. v_djxhstr_jqdcwj_arr.count loop
      select F_ZDSY_SHMC_ZS(v_djxhstr_jqdcwj_arr(i).djxh, 'SH')
        into v_sh_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_jqdcwj_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      select F_ZDSY_SHMC_ZS(v_djxhstr_jqdcwj_arr(i).djxh, 'MC')
        into v_mc_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_jqdcwj_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      v_str := v_bbq || v_split1 || v_sh_zs || v_split1 || v_mc_zs;
      dbms_lob.append(o_ret_txt, v_str);

      select *
        bulk collect
        into v_sb_zdsy_jqdcwj --����ҵ˰����Ϣ�������ֵ
        from sb_zdsy_jqdcwj t
       where t.djxh = v_djxhstr_jqdcwj_arr(i).djxh
            --and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z
       order by t.hc;

      for i in 1 .. v_sb_zdsy_jqdcwj.count loop
        if i < 36 then
          if i not in (4, 5, 9, 16, 19, 22, 27, 34, 35) then
            if v_sb_zdsy_jqdcwj(i)
             .COL01 <> 0 or v_sb_zdsy_jqdcwj(i).COL02 <> 0 or v_sb_zdsy_jqdcwj(i)
               .COL03 <> 0 or v_sb_zdsy_jqdcwj(i).COL04 <> 0 then
              case
                when v_sb_zdsy_jqdcwj(i).COL01 = 1 then
                  v_str := v_split1 || '0';
                when v_sb_zdsy_jqdcwj(i).COL02 = 1 then
                  v_str := v_split1 || '1';
                when v_sb_zdsy_jqdcwj(i).COL03 = 1 then
                  v_str := v_split1 || '2';
                when v_sb_zdsy_jqdcwj(i).COL04 = 1 then
                  v_str := v_split1 || '3';
                  --else v_str := v_split1 || '0';
              end case;
            else
              v_str := v_split1 || '0';
            end if;
            dbms_lob.append(o_ret_txt, v_str);
          end if;
        else
          v_str := v_split1 || v_sb_zdsy_jqdcwj(i).COL01 || v_split1 || v_sb_zdsy_jqdcwj(i)
                  .COL02 || v_split1 || v_sb_zdsy_jqdcwj(i).COL03 ||
                   v_split1 || v_sb_zdsy_jqdcwj(i).COL04;
          dbms_lob.append(o_ret_txt, v_str);
        end if;
      end loop;

      dbms_lob.append(o_ret_txt, v_br);

    end loop;

  END P_SB_EXPORT_JQDCWJ;

  procedure P_SB_EXPORT_QYJBXX(v_djxhstr_qyjbxx_arr IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                               i_splittag           IN number, --�ָ���
                               i_sssq_q             IN VARCHAR2, --����ʱ����
                               i_sssq_z             IN VARCHAR2, --����ʱ��ֹ
                               o_ret_txt            OUT CLOB --����ƴ�ӽ����
                               ) is

    type t_sb_zdsy_qyjbxx_rowtype is table of sb_zdsy_qyjbxx%rowtype index by binary_integer; --������ҵ������Ϣ������
    type t_colstr_arr is table of varchar2(100);

    v_sb_zdsy_qyjbxx    t_sb_zdsy_qyjbxx_rowtype; --���������Ϣ�����
    v_colstr_qyjbxx_arr t_colstr_arr := t_colstr_arr('E');
    --v_djxhstr_qyjbxx_arr TYPE_SPLIT := split_str(i_djxhs, ',');

    v_br       varchar2(10) := '##'; --�����ɵ�txt���滻Ϊ���з�
    v_bbq      varchar2(20); --�걨��ı�����
    v_split1   varchar2(10) := ','; --�������ص�txt�зָ����ݵı��
    v_tableTag varchar2(10) := 'XXB_'; --�걨����
    v_str      varchar2(2000); --ƴ��txt����ʱ����
    v_sh_zs    varchar2(100); --˰��չʾ����
    v_mc_zs    varchar2(100); --����չʾ����

  BEGIN

    if i_splittag = 1 then
      v_split1 := chr(9);
    end if;

    dbms_lob.createtemporary(o_ret_txt, true);
    --ƴ�ӱ�ͷ��Ϣ
    v_str := 'BBQ' || v_split1 || 'ID' || v_split1 || 'NAME';
    dbms_lob.append(o_ret_txt, v_str);

    for i in 1 .. v_djxhstr_qyjbxx_arr.count loop
      select *
        bulk collect
        into v_sb_zdsy_qyjbxx --����ҵ������Ϣ�������ֵ
        from sb_zdsy_qyjbxx t
       where t.djxh = v_djxhstr_qyjbxx_arr(i).djxh
         and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z;

      if v_sb_zdsy_qyjbxx.count > 0 then
        exit;
      end if;
    end loop;

    for i in 1 .. v_sb_zdsy_qyjbxx.count loop
      for j in 1 .. v_colstr_qyjbxx_arr.count loop
        v_str := v_split1 || v_tableTag || v_colstr_qyjbxx_arr(j) ||
                 to_char(i); --2017-09-26 Ϊ��trasϵͳ�е���ģ�壬�дδ�С-2
        dbms_lob.append(o_ret_txt, v_str);
      end loop;
    end loop;

    dbms_lob.append(o_ret_txt, v_br);

    --ƴ��ÿ�е�������Ϣ
    v_bbq := substr(i_sssq_q, 0, 4) || substr(i_sssq_q, 6, 2);
    for i in 1 .. v_djxhstr_qyjbxx_arr.count loop
      select F_ZDSY_SHMC_ZS(v_djxhstr_qyjbxx_arr(i).djxh, 'SH')
        into v_sh_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_qyjbxx_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      select F_ZDSY_SHMC_ZS(v_djxhstr_qyjbxx_arr(i).djxh, 'MC')
        into v_mc_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_qyjbxx_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      v_str := v_bbq || v_split1 || v_sh_zs || v_split1 || v_mc_zs;
      dbms_lob.append(o_ret_txt, v_str);

      select *
        bulk collect
        into v_sb_zdsy_qyjbxx --����ҵ˰����Ϣ�������ֵ
        from sb_zdsy_qyjbxx t
       where t.djxh = v_djxhstr_qyjbxx_arr(i).djxh
         and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z
       order by t.hc;

      for i in 1 .. v_sb_zdsy_qyjbxx.count loop
        v_str := v_split1 || v_sb_zdsy_qyjbxx(i).COL01;
        dbms_lob.append(o_ret_txt, v_str);
      end loop;

      dbms_lob.append(o_ret_txt, v_br);

    end loop;

  END P_SB_EXPORT_QYJBXX;

  procedure P_SB_EXPORT_CPSSB(v_djxhstr_cpssb_arr IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                              i_splittag          IN number, --�ָ���
                              i_sssq_q            IN VARCHAR2, --����ʱ����
                              i_sssq_z            IN VARCHAR2, --����ʱ��ֹ
                              o_ret_txt           OUT CLOB --����ƴ�ӽ����
                              ) is

    type t_sb_zdsy_cpssb_rowtype is table of sb_zdsy_cpssb%rowtype index by binary_integer; --������ҵ������Ϣ������
    type t_colstr_arr is table of varchar2(100);

    v_sb_zdsy_cpssb    t_sb_zdsy_cpssb_rowtype; --���������Ϣ�����
    v_colstr_cpssb_arr t_colstr_arr := t_colstr_arr('A',
                                                    'B',
                                                    'C',
                                                    'D',
                                                    'E',
                                                    'F',
                                                    'G',
                                                    'H',
                                                    'I',
                                                    'J',
                                                    'K',
                                                    'L',
                                                    'M',
                                                    'N',
                                                    'O',
                                                    'P',
                                                    'Q',
                                                    'R',
                                                    'S',
                                                    'T',
                                                    'U',
                                                    'V',
                                                    'W',
                                                    'X',
                                                    'Y',
                                                    'Z',
                                                    'AA',
                                                    'AB',
                                                    'AC',
                                                    'AD',
                                                    'AE',
                                                    'AF',
                                                    'AG',
                                                    'AH',
                                                    'AI',
                                                    'AJ',
                                                    'AK',
                                                    'AL');
    --v_djxhstr_cpssb_arr TYPE_SPLIT := split_str(i_djxhs, ',');

    v_br       varchar2(10) := '##'; --�����ɵ�txt���滻Ϊ���з�
    v_bbq      varchar2(20); --�걨��ı�����
    v_split1   varchar2(10) := ','; --�������ص�txt�зָ����ݵı��
    v_tableTag varchar2(10) := 'B2_'; --�걨����
    v_str      varchar2(4000); --ƴ��txt����ʱ����
    v_sh_zs    varchar2(100); --˰��չʾ����
    v_mc_zs    varchar2(100); --����չʾ����
    v_jbxx_str varchar2(2000); --ÿ������ǰ4�еĻ�����Ϣ����
  BEGIN

    if i_splittag = 1 then
      v_split1 := chr(9);
    end if;

    dbms_lob.createtemporary(o_ret_txt, true);
    --ƴ�ӱ�ͷ��Ϣ
    v_str := 'BBQ' || v_split1 || 'ID' || v_split1 || 'NAME';
    dbms_lob.append(o_ret_txt, v_str);

    for i in 1 .. v_djxhstr_cpssb_arr.count loop
      select *
        bulk collect
        into v_sb_zdsy_cpssb --����ҵ������Ϣ�������ֵ
        from sb_zdsy_cpssb t
       where t.djxh = v_djxhstr_cpssb_arr(i).djxh
         and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z;

      if v_sb_zdsy_cpssb.count > 0 then
        exit;
      end if;
    end loop;

    for j in 1 .. v_colstr_cpssb_arr.count loop
      v_str := v_split1 || v_tableTag || v_colstr_cpssb_arr(j) ||
               to_char(5);
      dbms_lob.append(o_ret_txt, v_str);
    end loop;

    dbms_lob.append(o_ret_txt, v_br);

    --ƴ��ÿ�е�������Ϣ
    v_bbq := substr(i_sssq_q, 0, 4) || substr(i_sssq_q, 6, 2);
    for i in 1 .. v_djxhstr_cpssb_arr.count loop
      select F_ZDSY_SHMC_ZS(v_djxhstr_cpssb_arr(i).djxh, 'SH')
        into v_sh_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_cpssb_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      select F_ZDSY_SHMC_ZS(v_djxhstr_cpssb_arr(i).djxh, 'MC')
        into v_mc_zs
        from SB_ZDSY_NSRRDQCXX t
       where t.djxh = v_djxhstr_cpssb_arr(i).djxh
         and t.shnd = to_char(sysdate, 'yyyy');
      v_jbxx_str := v_bbq || v_split1 || v_sh_zs || v_split1 || v_mc_zs;
      --dbms_lob.append(o_ret_txt, v_str);

      select *
        bulk collect
        into v_sb_zdsy_cpssb --����ҵ˰����Ϣ�������ֵ
        from sb_zdsy_cpssb t
       where t.djxh = v_djxhstr_cpssb_arr(i).djxh
         and sssq_q = i_sssq_q
         and sssq_z = i_sssq_z
       order by t.hc;

      for i in 1 .. v_sb_zdsy_cpssb.count loop
        v_str := v_jbxx_str || v_split1 || v_sb_zdsy_cpssb(i).CPDM ||
                 v_split1 || v_sb_zdsy_cpssb(i).DW || v_split1 || v_sb_zdsy_cpssb(i).COL3 ||
                 v_split1 || v_sb_zdsy_cpssb(i).COL4 || v_split1 || v_sb_zdsy_cpssb(i).COL5 ||
                 v_split1 || v_sb_zdsy_cpssb(i).COL6 || v_split1 || v_sb_zdsy_cpssb(i).COL7 ||
                 v_split1 || v_sb_zdsy_cpssb(i).COL8 || v_split1 || v_sb_zdsy_cpssb(i).COL9 ||
                 v_split1 || v_sb_zdsy_cpssb(i).COL10 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL11 || v_split1 || v_sb_zdsy_cpssb(i).COL12 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL13 || v_split1 || v_sb_zdsy_cpssb(i).COL14 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL15 || v_split1 || v_sb_zdsy_cpssb(i).COL16 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL17 || v_split1 || v_sb_zdsy_cpssb(i).COL18 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL19 || v_split1 || v_sb_zdsy_cpssb(i).COL20 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL23 || v_split1 || v_sb_zdsy_cpssb(i).COL24 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL25 || v_split1 || v_sb_zdsy_cpssb(i).COL26 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL27 || v_split1 || v_sb_zdsy_cpssb(i).COL28 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL29 || v_split1 || v_sb_zdsy_cpssb(i).COL30 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL31 || v_split1 || v_sb_zdsy_cpssb(i).COL32 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL33 || v_split1 || v_sb_zdsy_cpssb(i).COL34 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL35 || v_split1 || v_sb_zdsy_cpssb(i).COL36 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL37 || v_split1 || v_sb_zdsy_cpssb(i).COL38 || v_split1 || v_sb_zdsy_cpssb(i)
                .COL39 || v_split1 || v_sb_zdsy_cpssb(i).COL40;
        dbms_lob.append(o_ret_txt, v_str);
        dbms_lob.append(o_ret_txt, v_br);
      end loop;

    --dbms_lob.append(o_ret_txt, v_br);

    end loop;

  END P_SB_EXPORT_CPSSB;

  procedure P_SB_EXPORT_SHB(v_djxhstr_shb_arr IN t_sb_zdsy_djxhs_rowtype, --��˰��ʶ���
                            i_splittag        IN number, --�ָ���
                            i_sssq_q          IN VARCHAR2, --����ʱ����
                            i_sssq_z          IN VARCHAR2, --����ʱ��ֹ
                            o_ret_txt         OUT CLOB --����ƴ�ӽ����
                            ) is

    --type t_sb_zdsy_shb_rowtype is table of tab_zdsy_shb_txt%rowtype index by binary_integer;
    TYPE v_sb_zdsy_shb_cols IS RECORD(
      sbbxh  sb_zdsy_yw_sh.sbbxh%TYPE,
      nsrsbh sb_zdsy_yw_sh.nsrsbh%TYPE,
      sssq_q sb_zdsy_yw_sh.sssq_q%TYPE,
      sssq_z sb_zdsy_yw_sh.sssq_z%TYPE,
      tbrq   sb_zdsy_yw_sh.tbrq%TYPE,
      djxh   sb_zdsy_yw_sh.djxh%TYPE,
      shbj   sb_zdsy_yw_sh.shbj%TYPE,
      txsm   sb_zdsy_yw_sh.txsm%TYPE,
      hc     sb_zdsy_yw_sh.hc%TYPE,
      shgs   sb_zdsy_shb.shgs%TYPE,
      shsm   sb_zdsy_shb.shsm%TYPE,
      ywdm   sb_zdsy_shb.ywdm%TYPE,
      isbn   sb_zdsy_shb.isbn%TYPE);
    TYPE t_sb_zdsy_shb_rowtype IS TABLE OF v_sb_zdsy_shb_cols;
    v_sb_zdsy_shb t_sb_zdsy_shb_rowtype;

    type t_colstr_arr is table of varchar2(100);

    v_colstr_shb_arr t_colstr_arr := t_colstr_arr('A',
                                                  'B',
                                                  'C',
                                                  'D',
                                                  'E',
                                                  'F');
    --v_djxhstr_shb_arr TYPE_SPLIT := split_str(i_djxhs, ',');

    v_br       varchar2(10) := '##'; --�����ɵ�txt���滻Ϊ���з�
    v_bbq      varchar2(20); --�걨��ı�����
    v_split1   varchar2(10) := ','; --�������ص�txt�зָ����ݵı��
    v_tableTag varchar2(10) := 'SHB_'; --�걨����
    v_str      varchar2(2000); --ƴ��txt����ʱ����
    v_sh_zs    varchar2(100); --˰��չʾ����
    v_mc_zs    varchar2(100); --����չʾ����
  BEGIN

    if i_splittag = 1 then
      v_split1 := chr(9);
    end if;

    dbms_lob.createtemporary(o_ret_txt, true);
    --ƴ�ӱ�ͷ��Ϣ
    /*v_str := 'BBQ' || v_split1 || 'ID' || v_split1 || '����' ||
    v_split1 || '�䳤��ؼ���' || v_split1 || '���tag' || v_split1 || '��˹�ʽ' ||
    v_split1 || '������˵��' || v_split1 || '�����ʾ��Ϣ';*/

    v_str := 'BBQ' || v_split1 || 'ID' || v_split1 || 'NAME' || v_split1 ||
             'B5_A2' || v_split1 || 'B5_B2' || v_split1 || 'B5_C2' ||
             v_split1 || 'B5_D2' || v_split1 || 'B5_E2' || v_split1 ||
             'B5_F2';

    dbms_lob.append(o_ret_txt, v_str);

    dbms_lob.append(o_ret_txt, v_br);

    --ƴ��ÿ�е�������Ϣ
    v_bbq := substr(i_sssq_q, 0, 4) || substr(i_sssq_q, 6, 2);
    for i in 1 .. v_djxhstr_shb_arr.count loop

      select w.sbbxh,
             w.nsrsbh,
             w.sssq_q,
             w.sssq_z,
             w.tbrq,
             w.djxh,
             w.shbj,
             w.txsm,
             w.hc,
             t.shgs,
             t.shsm,
             decode(t.ywdm,
                    'SB_ZDSY_QYJBXX',
                    'XXB',
                    'SB_ZDSY_CPSSB',
                    'B2',
                    'SB_ZDSY_JQDCWJ',
                    'B4',
                    'SB_ZDSY_CWXX',
                    'B3',
                    'SB_ZDSY_QYSSXX',
                    'B1',
                    'B5') ywdm,
             t.isbn
        bulk collect
        into v_sb_zdsy_shb
        from sb_zdsy_yw_sh w
        left join SB_ZDSY_SHB T
          on t.shbj = w.shbj
         and t.isbn = w.isbn
       where w.djxh = v_djxhstr_shb_arr(i).djxh
         and w.sssq_z = i_sssq_z;
      --and t.yxbz = 'Y';

      for j in 1 .. v_sb_zdsy_shb.count loop
        select F_ZDSY_SHMC_ZS(v_djxhstr_shb_arr(i).djxh, 'SH')
          into v_sh_zs
          from SB_ZDSY_NSRRDQCXX t
         where t.djxh = v_djxhstr_shb_arr(i).djxh
           and t.shnd = to_char(sysdate, 'yyyy');
        select F_ZDSY_SHMC_ZS(v_djxhstr_shb_arr(i).djxh, 'MC')
          into v_mc_zs
          from SB_ZDSY_NSRRDQCXX t
         where t.djxh = v_djxhstr_shb_arr(i).djxh
           and t.shnd = to_char(sysdate, 'yyyy');
        v_str := v_bbq || v_split1 || v_sh_zs || v_split1 || v_mc_zs ||
                 v_split1 || v_sb_zdsy_shb(j).YWDM || v_split1 || 'NULL' ||
                 v_split1 || v_sb_zdsy_shb(j).SHBJ || v_split1 || v_sb_zdsy_shb(j).SHGS ||
                 v_split1 || v_sb_zdsy_shb(j).txsm || v_split1 || v_sb_zdsy_shb(j).SHSM;

        dbms_lob.append(o_ret_txt, v_str);
        dbms_lob.append(o_ret_txt, v_br);
      end loop;

    end loop;

  END P_SB_EXPORT_SHB;

  procedure P_SB_test(i_ywdm     in varchar2,
                      i_splittag in number,
                      i_djxhs    in varchar2,
                      i_sssq_q   in varchar2,
                      i_sssq_z   in varchar2,
                      o_txt      out CLOB) is

    str varchar2(1000);

  begin

    str := '10114101000241806464,10114101000241246781';

    /*IF (i_ywdm = 'SB_ZDSY_QYSSXX') THEN
       P_SB_EXPORT_QYSSXX(i_djxhs,i_splittag,i_sssq_q,i_sssq_z,o_txt); --˰�ձ�
    END IF;

    IF (i_ywdm = 'SB_ZDSY_CWXX') THEN
         P_SB_EXPORT_CWBB(i_djxhs,i_splittag,i_sssq_q,i_sssq_z,o_txt); --�����
    END IF;

    IF (i_ywdm = 'SB_ZDSY_JQDCWJ') THEN
      P_SB_EXPORT_JQDCWJ(i_djxhs,i_splittag,i_sssq_q,i_sssq_z,o_txt); --�����ʾ�

    END IF;

    IF (i_ywdm = 'SB_ZDSY_QYJBXX') THEN
      P_SB_EXPORT_QYJBXX(i_djxhs,i_splittag,i_sssq_q,i_sssq_z,o_txt); --������Ϣ��

    END IF;

    IF (i_ywdm = 'SB_ZDSY_CPSSB') THEN
      P_SB_EXPORT_CPSSB(i_djxhs,i_splittag,i_sssq_q,i_sssq_z,o_txt); --˰�ղ�Ʒ��

    END IF;

    IF (i_ywdm = 'SB_ZDSY_SHB') THEN
      P_SB_EXPORT_SHB(i_djxhs,i_splittag,i_sssq_q,i_sssq_z,o_txt); --��˻��ܱ�

    END IF;*/

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      o_txt := '�洢���̳���';
      /*dbms_output.put_line('**Error line:' ||
                           dbms_utility.format_error_backtrace());
      dbms_output.put_line('**Error code:' || SQLCODE);
      dbms_output.put_line('**Error info:' || SQLERRM);
      return;*/
  END P_SB_test;

end PKG_SB_ZDSY_SBB_TXT;












/
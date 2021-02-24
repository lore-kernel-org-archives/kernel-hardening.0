Return-Path: <SRS0=3cMV=H2=lists.openwall.com=kernel-hardening-return-20819-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB1EC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 16:55:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1530364F07
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 16:55:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1530364F07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20819-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17712 invoked by uid 550); 24 Feb 2021 16:55:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17686 invoked from network); 24 Feb 2021 16:55:00 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: kernel test robot <oliver.sang@intel.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,  0day robot <lkp@intel.com>,  LKML <linux-kernel@vger.kernel.org>,  lkp@lists.01.org,  ying.huang@intel.com,  feng.tang@intel.com,  zhengjun.xing@intel.com,  io-uring@vger.kernel.org,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <20210224051845.GB6114@xsang-OptiPlex-9020>
Date: Wed, 24 Feb 2021 10:54:17 -0600
In-Reply-To: <20210224051845.GB6114@xsang-OptiPlex-9020> (kernel test robot's
	message of "Wed, 24 Feb 2021 13:18:45 +0800")
Message-ID: <m1czwpl83q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1lExQo-0002Bt-T5;;;mid=<m1czwpl83q.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18PUPfhz92CNLtiv/7aFzG939PKvVvDJaY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: d28296d248:  stress-ng.sigsegv.ops_per_sec -82.7% regression
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

kernel test robot <oliver.sang@intel.com> writes:

> Greeting,
>
> FYI, we noticed a -82.7% regression of stress-ng.sigsegv.ops_per_sec due =
to commit:
>
>
> commit: d28296d2484fa11e94dff65e93eb25802a443d47 ("[PATCH v7 5/7] Reimple=
ment RLIMIT_SIGPENDING on top of ucounts")
> url: https://github.com/0day-ci/linux/commits/Alexey-Gladkov/Count-rlimit=
s-in-each-user-namespace/20210222-175836
> base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.=
git next
>
> in testcase: stress-ng
> on test machine: 48 threads Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz wit=
h 112G memory
> with following parameters:
>
> 	nr_threads: 100%
> 	disk: 1HDD
> 	testtime: 60s
> 	class: interrupt
> 	test: sigsegv
> 	cpufreq_governor: performance
> 	ucode: 0x42e
>
>
> In addition to that, the commit also has significant impact on the
> following tests:

Thank you.  Now we have a sense of where we need to test the performance
of these changes carefully.

Eric


> +------------------+-----------------------------------------------------=
------------------+
> | testcase: change | stress-ng: stress-ng.sigq.ops_per_sec -56.1% regress=
ion               |
> | test machine     | 48 threads Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz=
 with 112G memory |
> | test parameters  | class=3Dinterrupt                                   =
                    |
> |                  | cpufreq_governor=3Dperformance                      =
                    |
> |                  | disk=3D1HDD                                         =
                    |
> |                  | nr_threads=3D100%                                   =
                    |
> |                  | test=3Dsigq                                         =
                    |
> |                  | testtime=3D60s                                      =
                    |
> |                  | ucode=3D0x42e                                       =
                    |
> +------------------+-----------------------------------------------------=
------------------+
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
>
> Details are as below:
> -------------------------------------------------------------------------=
------------------------->
>
>
> To reproduce:
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp install                job.yaml  # job file is attached i=
n this email
>         bin/lkp split-job --compatible job.yaml
>         bin/lkp run                    compatible-job.yaml
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> class/compiler/cpufreq_governor/disk/kconfig/nr_threads/rootfs/tbox_group=
/test/testcase/testtime/ucode:
>   interrupt/gcc-9/performance/1HDD/x86_64-rhel-8.3/100%/debian-10.4-x86_6=
4-20200603.cgz/lkp-ivb-2ep1/sigsegv/stress-ng/60s/0x42e
>
> commit:=20
>   4660d663b4 ("Reimplement RLIMIT_MSGQUEUE on top of ucounts")
>   d28296d248 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
>
> 4660d663b4207ce6 d28296d2484fa11e94dff65e93e=20
> ---------------- ---------------------------=20
>        fail:runs  %reproduction    fail:runs
>            |             |             |=20=20=20=20
>          14:6         -217%           1:6     perf-profile.children.cycle=
s-pp.error_entry
>          12:6         -179%           1:6     perf-profile.self.cycles-pp=
.error_entry
>          %stddev     %change         %stddev
>              \          |                \=20=20
>  4.766e+08           -82.7%   82358308        stress-ng.sigsegv.ops
>    7942807           -82.7%    1372639        stress-ng.sigsegv.ops_per_s=
ec
>      29408           -77.5%       6621 =C2=B1 61%  stress-ng.time.file_sy=
stem_inputs
>       1566           +69.4%       2653        stress-ng.time.system_time
>       1274           -84.8%     193.22 =C2=B1  8%  stress-ng.time.user_ti=
me
>      12458 =C2=B1  5%     +37.2%      17097 =C2=B1  5%  numa-meminfo.node=
1.Active(anon)
>      51.41           +66.5%      85.59        iostat.cpu.system
>      41.17           -84.2%       6.50 =C2=B1  7%  iostat.cpu.user
>       3040 =C2=B1  4%     +37.9%       4193 =C2=B1  4%  numa-vmstat.node1=
.nr_active_anon
>       3040 =C2=B1  4%     +37.9%       4193 =C2=B1  4%  numa-vmstat.node1=
.nr_zone_active_anon
>      50.83           +67.2%      85.00        vmstat.cpu.sy
>      40.50           -85.6%       5.83 =C2=B1 11%  vmstat.cpu.us
>     225.33           -77.7%      50.33 =C2=B1 62%  vmstat.io.bi
>       7.00          -100.0%       0.00        vmstat.memory.buff
>      20735 =C2=B1  2%     -14.1%      17812 =C2=B1  5%  meminfo.Active
>      13506 =C2=B1  3%     +31.9%      17812 =C2=B1  5%  meminfo.Active(an=
on)
>       7228          -100.0%       0.00        meminfo.Active(file)
>      29308           +18.4%      34687 =C2=B1  2%  meminfo.Shmem
>     202067            -9.5%     182899        meminfo.VmallocUsed
>       0.01 =C2=B1 17%      -0.0        0.00 =C2=B1 10%  mpstat.cpu.all.io=
wait%
>       1.04            -0.1        0.92        mpstat.cpu.all.irq%
>       0.03 =C2=B1  8%      -0.0        0.02 =C2=B1  4%  mpstat.cpu.all.so=
ft%
>      51.54           +35.6       87.17        mpstat.cpu.all.sys%
>      42.22           -35.6        6.66 =C2=B1  8%  mpstat.cpu.all.usr%
>       0.00 =C2=B1 70%    +191.7%       0.01 =C2=B1 26%  perf-sched.sch_de=
lay.avg.ms.__sched_text_start.__sched_text_start.worker_thread.kthread.ret_=
from_fork
>       0.00 =C2=B1 47%    +158.8%       0.01 =C2=B1 43%  perf-sched.sch_de=
lay.max.ms.__sched_text_start.__sched_text_start.worker_thread.kthread.ret_=
from_fork
>       0.27 =C2=B1 25%     -55.4%       0.12 =C2=B1 37%  perf-sched.total_=
wait_and_delay.average.ms
>     202.17 =C2=B1 23%     -29.5%     142.50 =C2=B1 13%  perf-sched.total_=
wait_and_delay.count.ms
>       0.21 =C2=B1 18%     -69.3%       0.06 =C2=B1 58%  perf-sched.total_=
wait_time.average.ms
>       0.00 =C2=B1 70%    +191.7%       0.01 =C2=B1 26%  perf-sched.wait_a=
nd_delay.avg.ms.__sched_text_start.__sched_text_start.worker_thread.kthread=
.ret_from_fork
>       8.17 =C2=B1 29%     -85.7%       1.17 =C2=B1125%  perf-sched.wait_a=
nd_delay.count.__sched_text_start.__sched_text_start.schedule_timeout.rcu_g=
p_kthread.kthread
>       0.00 =C2=B1 47%    +158.8%       0.01 =C2=B1 43%  perf-sched.wait_a=
nd_delay.max.ms.__sched_text_start.__sched_text_start.worker_thread.kthread=
.ret_from_fork
>       3.11 =C2=B1 11%     -76.1%       0.74 =C2=B1142%  perf-sched.wait_t=
ime.avg.ms.__sched_text_start.__sched_text_start.schedule_timeout.rcu_gp_kt=
hread.kthread
>       1790 =C2=B1 15%     -30.1%       1250 =C2=B1 13%  slabinfo.dmaengin=
e-unmap-16.active_objs
>       1790 =C2=B1 15%     -30.1%       1250 =C2=B1 13%  slabinfo.dmaengin=
e-unmap-16.num_objs
>     123.00          -100.0%       0.00        slabinfo.ext4_pending_reser=
vation.active_objs
>     123.00          -100.0%       0.00        slabinfo.ext4_pending_reser=
vation.num_objs
>       3619          -100.0%       0.00        slabinfo.f2fs_free_nid.acti=
ve_objs
>       3619          -100.0%       0.00        slabinfo.f2fs_free_nid.num_=
objs
>      62865           -44.1%      35155        slabinfo.kmalloc-64.active_=
objs
>     984.33           -43.9%     552.50        slabinfo.kmalloc-64.active_=
slabs
>      63031           -43.9%      35389        slabinfo.kmalloc-64.num_objs
>     984.33           -43.9%     552.50        slabinfo.kmalloc-64.num_sla=
bs
>     161.00 =C2=B1  9%     +67.1%     269.00 =C2=B1  7%  slabinfo.xfs_buf.=
active_objs
>     161.00 =C2=B1  9%     +67.1%     269.00 =C2=B1  7%  slabinfo.xfs_buf.=
num_objs
>       3399 =C2=B1  3%     +32.9%       4519 =C2=B1  4%  proc-vmstat.nr_ac=
tive_anon
>       1806          -100.0%       0.00        proc-vmstat.nr_active_file
>       9333            +3.0%       9610        proc-vmstat.nr_mapped
>       7344           +18.4%       8698 =C2=B1  2%  proc-vmstat.nr_shmem
>      16319            -0.9%      16176        proc-vmstat.nr_slab_reclaim=
able
>      24399            -6.2%      22882        proc-vmstat.nr_slab_unrecla=
imable
>       3399 =C2=B1  3%     +32.9%       4519 =C2=B1  4%  proc-vmstat.nr_zo=
ne_active_anon
>       1806          -100.0%       0.00        proc-vmstat.nr_zone_active_=
file
>       3693 =C2=B1 80%     -80.1%     736.17 =C2=B1 61%  proc-vmstat.numa_=
hint_faults
>     293002            -2.7%     284991        proc-vmstat.numa_hit
>     249530            -3.3%     241180        proc-vmstat.numa_local
>       5007 =C2=B1111%     -90.5%     478.00 =C2=B1 81%  proc-vmstat.numa_=
pages_migrated
>      11443 =C2=B1  2%      -7.0%      10636 =C2=B1  4%  proc-vmstat.pgact=
ivate
>     332528            -3.9%     319693        proc-vmstat.pgalloc_normal
>     249148 =C2=B1  2%      -4.1%     239053 =C2=B1  2%  proc-vmstat.pgfree
>       5007 =C2=B1111%     -90.5%     478.00 =C2=B1 81%  proc-vmstat.pgmig=
rate_success
>      14704           -77.5%       3310 =C2=B1 61%  proc-vmstat.pgpgin
>       0.00       +2.1e+105%       2095        proc-vmstat.pgpgout
>      13870 =C2=B1 10%     -55.1%       6227 =C2=B1 28%  softirqs.CPU0.RCU
>       9989 =C2=B1  3%     -62.2%       3775 =C2=B1 23%  softirqs.CPU1.RCU
>       8625 =C2=B1 13%     -76.1%       2061 =C2=B1 10%  softirqs.CPU10.RCU
>       7954 =C2=B1 15%     -65.9%       2709 =C2=B1 18%  softirqs.CPU14.RCU
>       9075 =C2=B1 14%     -78.7%       1929 =C2=B1 11%  softirqs.CPU17.RCU
>       8522 =C2=B1 13%     -76.7%       1985 =C2=B1 22%  softirqs.CPU18.RCU
>       9595 =C2=B1  7%     -63.3%       3522 =C2=B1 22%  softirqs.CPU2.RCU
>       8455 =C2=B1 11%     -74.5%       2152 =C2=B1 45%  softirqs.CPU20.RCU
>       8320 =C2=B1 12%     -76.7%       1939 =C2=B1 14%  softirqs.CPU21.RCU
>       8338 =C2=B1 13%     -71.7%       2359 =C2=B1 32%  softirqs.CPU23.RCU
>       8541 =C2=B1 12%     -75.5%       2089 =C2=B1 32%  softirqs.CPU26.RCU
>       9639 =C2=B1 20%     -79.5%       1976 =C2=B1 17%  softirqs.CPU28.RCU
>       9232 =C2=B1 13%     -78.0%       2026 =C2=B1  6%  softirqs.CPU30.RCU
>       7857 =C2=B1 17%     -68.9%       2446 =C2=B1 27%  softirqs.CPU34.RCU
>       8619 =C2=B1 11%     -75.8%       2081 =C2=B1 30%  softirqs.CPU36.RCU
>       9614 =C2=B1  3%     -74.3%       2469 =C2=B1 15%  softirqs.CPU4.RCU
>       8962 =C2=B1 10%     -77.9%       1981 =C2=B1 12%  softirqs.CPU41.RCU
>       9027 =C2=B1 12%     -78.6%       1932 =C2=B1  8%  softirqs.CPU42.RCU
>       9364 =C2=B1 12%     -76.5%       2197 =C2=B1  8%  softirqs.CPU44.RCU
>       8774 =C2=B1 13%     -75.5%       2147 =C2=B1 21%  softirqs.CPU47.RCU
>       8783 =C2=B1 12%     -76.0%       2105 =C2=B1 12%  softirqs.CPU5.RCU
>       9007 =C2=B1  9%     -75.8%       2177 =C2=B1  8%  softirqs.CPU6.RCU
>     417664 =C2=B1  7%     -72.8%     113621 =C2=B1  8%  softirqs.RCU
>      12708 =C2=B1  4%     +13.0%      14362 =C2=B1  2%  softirqs.TIMER
>      60500           -27.7%      43751        interrupts.CAL:Function_cal=
l_interrupts
>       1121           -26.9%     819.17 =C2=B1  3%  interrupts.CPU10.CAL:F=
unction_call_interrupts
>       1561 =C2=B1 43%     -48.8%     800.00 =C2=B1  5%  interrupts.CPU11.=
CAL:Function_call_interrupts
>       1425 =C2=B1  6%     -25.3%       1065 =C2=B1  6%  interrupts.CPU12.=
CAL:Function_call_interrupts
>     166.17 =C2=B1 13%     -26.4%     122.33 =C2=B1 21%  interrupts.CPU13.=
RES:Rescheduling_interrupts
>       1402 =C2=B1 18%     -25.6%       1043 =C2=B1 22%  interrupts.CPU15.=
CAL:Function_call_interrupts
>     129.17 =C2=B1 50%     -42.5%      74.33 =C2=B1  4%  interrupts.CPU17.=
RES:Rescheduling_interrupts
>       1182 =C2=B1  9%     -31.0%     815.00 =C2=B1  2%  interrupts.CPU20.=
CAL:Function_call_interrupts
>       1120           -29.7%     787.17 =C2=B1  4%  interrupts.CPU21.CAL:F=
unction_call_interrupts
>       1115 =C2=B1  3%     -28.2%     801.17        interrupts.CPU23.CAL:F=
unction_call_interrupts
>       1169 =C2=B1  7%     -27.2%     851.33 =C2=B1  5%  interrupts.CPU24.=
CAL:Function_call_interrupts
>     177.33 =C2=B1 98%     -55.9%      78.17 =C2=B1  6%  interrupts.CPU25.=
RES:Rescheduling_interrupts
>       1142 =C2=B1 16%     -28.8%     813.00 =C2=B1  3%  interrupts.CPU27.=
CAL:Function_call_interrupts
>       1229 =C2=B1 18%     -33.3%     820.33 =C2=B1  4%  interrupts.CPU28.=
CAL:Function_call_interrupts
>       1124 =C2=B1  4%     -28.3%     806.17        interrupts.CPU29.CAL:F=
unction_call_interrupts
>       1123 =C2=B1  3%     -28.5%     803.00        interrupts.CPU30.CAL:F=
unction_call_interrupts
>       1127 =C2=B1  2%     -32.0%     766.67 =C2=B1 19%  interrupts.CPU31.=
CAL:Function_call_interrupts
>       1066 =C2=B1  8%     -22.3%     829.33 =C2=B1  7%  interrupts.CPU32.=
CAL:Function_call_interrupts
>       1109           -26.0%     820.50 =C2=B1  4%  interrupts.CPU34.CAL:F=
unction_call_interrupts
>       1315 =C2=B1 22%     -37.7%     818.83 =C2=B1  2%  interrupts.CPU38.=
CAL:Function_call_interrupts
>       1164 =C2=B1  4%     -29.0%     827.00 =C2=B1  3%  interrupts.CPU39.=
CAL:Function_call_interrupts
>       5513 =C2=B1 35%     +13.1%       6237 =C2=B1 33%  interrupts.CPU39.=
NMI:Non-maskable_interrupts
>       5513 =C2=B1 35%     +13.1%       6237 =C2=B1 33%  interrupts.CPU39.=
PMI:Performance_monitoring_interrupts
>       1277 =C2=B1 23%     -36.1%     815.83        interrupts.CPU40.CAL:F=
unction_call_interrupts
>      97.33 =C2=B1 28%     -25.7%      72.33 =C2=B1  6%  interrupts.CPU40.=
RES:Rescheduling_interrupts
>       1116           -24.8%     839.00 =C2=B1 11%  interrupts.CPU42.CAL:F=
unction_call_interrupts
>       1130 =C2=B1  3%     -28.5%     808.67 =C2=B1  3%  interrupts.CPU43.=
CAL:Function_call_interrupts
>       1121           -29.8%     787.50 =C2=B1  4%  interrupts.CPU45.CAL:F=
unction_call_interrupts
>       1119           -27.3%     813.83        interrupts.CPU46.CAL:Functi=
on_call_interrupts
>       1167 =C2=B1  6%     -28.0%     840.67        interrupts.CPU47.CAL:F=
unction_call_interrupts
>       1667 =C2=B1 41%     -44.3%     928.67 =C2=B1 24%  interrupts.CPU5.C=
AL:Function_call_interrupts
>       1369 =C2=B1 24%     -39.5%     827.67 =C2=B1  3%  interrupts.CPU6.C=
AL:Function_call_interrupts
>      96.83 =C2=B1 25%     -23.1%      74.50 =C2=B1  2%  interrupts.CPU7.R=
ES:Rescheduling_interrupts
>       1123           -28.1%     807.00        interrupts.CPU9.CAL:Functio=
n_call_interrupts
>       0.72 =C2=B1  5%    +107.4%       1.50 =C2=B1  2%  perf-stat.i.MPKI
>  8.023e+09           -13.5%  6.943e+09        perf-stat.i.branch-instruct=
ions
>       1.08 =C2=B1  2%      -0.5        0.55 =C2=B1  3%  perf-stat.i.branc=
h-miss-rate%
>   71073978 =C2=B1  2%     -67.4%   23149119 =C2=B1  3%  perf-stat.i.branc=
h-misses
>      29.33 =C2=B1  2%      +5.9       35.23        perf-stat.i.cache-miss=
-rate%
>    6189596          +120.2%   13628525        perf-stat.i.cache-misses
>   21228048           +82.4%   38714786        perf-stat.i.cache-references
>       3.36           +34.8%       4.53        perf-stat.i.cpi
>     109.52 =C2=B1  2%     -22.5%      84.92        perf-stat.i.cpu-migrat=
ions
>      22695           -56.5%       9882        perf-stat.i.cycles-between-=
cache-misses
>       1.15 =C2=B1  7%      -0.9        0.30 =C2=B1  4%  perf-stat.i.dTLB-=
load-miss-rate%
>  1.398e+08 =C2=B1  7%     -83.4%   23247225 =C2=B1  4%  perf-stat.i.dTLB-=
load-misses
>  1.154e+10           -34.4%  7.564e+09        perf-stat.i.dTLB-loads
>       1.17            -0.0        1.13        perf-stat.i.dTLB-store-miss=
-rate%
>  1.321e+08           -82.1%   23679743        perf-stat.i.dTLB-store-miss=
es
>  1.071e+10           -81.3%  2.005e+09        perf-stat.i.dTLB-stores
>   41869658           -74.5%   10693569 =C2=B1 56%  perf-stat.i.iTLB-load-=
misses
>   19932113 =C2=B1 38%     -88.3%    2325708 =C2=B1 64%  perf-stat.i.iTLB-=
loads
>  3.945e+10           -25.9%  2.924e+10        perf-stat.i.instructions
>       1199 =C2=B1  4%    +182.7%       3389 =C2=B1 26%  perf-stat.i.instr=
uctions-per-iTLB-miss
>       0.31           -23.7%       0.24        perf-stat.i.ipc
>     634.71           -45.5%     345.81        perf-stat.i.metric.M/sec
>     166710 =C2=B1 10%   +3369.3%    5783625        perf-stat.i.node-load-=
misses
>     227268 =C2=B1  6%   +3063.1%    7188743        perf-stat.i.node-loads
>      48.41            -4.5       43.91        perf-stat.i.node-store-miss=
-rate%
>    5425859           -11.8%    4783945        perf-stat.i.node-store-miss=
es
>    5599687            +6.1%    5943407        perf-stat.i.node-stores
>    7532204           -82.7%    1305118        perf-stat.i.page-faults
>       0.54          +146.0%       1.32        perf-stat.overall.MPKI
>       0.89 =C2=B1  2%      -0.6        0.33 =C2=B1  3%  perf-stat.overall=
.branch-miss-rate%
>      29.17 =C2=B1  2%      +6.0       35.20        perf-stat.overall.cach=
e-miss-rate%
>       3.45           +35.0%       4.65        perf-stat.overall.cpi
>      21953           -54.5%       9979        perf-stat.overall.cycles-be=
tween-cache-misses
>       1.20 =C2=B1  7%      -0.9        0.31 =C2=B1  4%  perf-stat.overall=
.dTLB-load-miss-rate%
>       1.22            -0.1        1.17        perf-stat.overall.dTLB-stor=
e-miss-rate%
>     942.39          +245.5%       3255 =C2=B1 28%  perf-stat.overall.inst=
ructions-per-iTLB-miss
>       0.29           -25.9%       0.21        perf-stat.overall.ipc
>      42.24 =C2=B1  2%      +2.3       44.58        perf-stat.overall.node=
-load-miss-rate%
>      49.21            -4.6       44.59        perf-stat.overall.node-stor=
e-miss-rate%
>  7.894e+09           -13.5%   6.83e+09        perf-stat.ps.branch-instruc=
tions
>   69952381 =C2=B1  2%     -67.4%   22781972 =C2=B1  3%  perf-stat.ps.bran=
ch-misses
>    6093197          +120.1%   13409962        perf-stat.ps.cache-misses
>   20897937           +82.3%   38097787        perf-stat.ps.cache-referenc=
es
>     107.78 =C2=B1  2%     -22.4%      83.62        perf-stat.ps.cpu-migra=
tions
>  1.375e+08 =C2=B1  7%     -83.4%   22871450 =C2=B1  4%  perf-stat.ps.dTLB=
-load-misses
>  1.135e+10           -34.4%  7.442e+09        perf-stat.ps.dTLB-loads
>    1.3e+08           -82.1%   23295591        perf-stat.ps.dTLB-store-mis=
ses
>  1.054e+10           -81.3%  1.973e+09        perf-stat.ps.dTLB-stores
>   41193894           -74.5%   10519305 =C2=B1 56%  perf-stat.ps.iTLB-load=
-misses
>   19610606 =C2=B1 38%     -88.3%    2288293 =C2=B1 64%  perf-stat.ps.iTLB=
-loads
>  3.882e+10           -25.9%  2.876e+10        perf-stat.ps.instructions
>     164152 =C2=B1 10%   +3366.2%    5689843        perf-stat.ps.node-load=
-misses
>     223940 =C2=B1  6%   +3058.2%    7072454        perf-stat.ps.node-loads
>    5338769           -11.8%    4706549        perf-stat.ps.node-store-mis=
ses
>    5510338            +6.1%    5847491        perf-stat.ps.node-stores
>    7410609           -82.7%    1283937        perf-stat.ps.page-faults
>  2.454e+12           -25.9%  1.817e+12        perf-stat.total.instructions
>      33.68           -29.6        4.04        perf-profile.calltrace.cycl=
es-pp.entry_SYSCALL_64_after_hwframe
>      18.94           -16.5        2.46        perf-profile.calltrace.cycl=
es-pp.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
>      13.67           -12.3        1.42        perf-profile.calltrace.cycl=
es-pp.syscall_return_via_sysret
>      12.27           -10.9        1.36 =C2=B1  2%  perf-profile.calltrace=
.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       8.04            -7.0        1.05 =C2=B1  2%  perf-profile.calltrace=
.cycles-pp.__entry_text_start
>       6.06            -6.1        0.00        perf-profile.calltrace.cycl=
es-pp.entry_SYSCALL_64_safe_stack
>       6.02 =C2=B1  2%      -5.4        0.66 =C2=B1  2%  perf-profile.call=
trace.cycles-pp.__x64_sys_rt_sigaction.do_syscall_64.entry_SYSCALL_64_after=
_hwframe
>       5.51            -4.8        0.70        perf-profile.calltrace.cycl=
es-pp.__setup_rt_frame.arch_do_signal_or_restart.exit_to_user_mode_prepare.=
irqentry_exit_to_user_mode.asm_exc_page_fault
>       0.00            +0.6        0.65        perf-profile.calltrace.cycl=
es-pp.inc_rlimit_ucounts_and_test.__sigqueue_alloc.__send_signal.force_sig_=
info_to_task.force_sig_fault
>      18.91           +27.0       45.89        perf-profile.calltrace.cycl=
es-pp.irqentry_exit_to_user_mode.asm_exc_page_fault
>      15.00           +30.4       45.42        perf-profile.calltrace.cycl=
es-pp.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fau=
lt
>      14.66           +30.7       45.38        perf-profile.calltrace.cycl=
es-pp.arch_do_signal_or_restart.exit_to_user_mode_prepare.irqentry_exit_to_=
user_mode.asm_exc_page_fault
>      11.73           +34.2       45.97        perf-profile.calltrace.cycl=
es-pp.exc_page_fault.asm_exc_page_fault
>       8.85           +36.7       45.54        perf-profile.calltrace.cycl=
es-pp.__bad_area_nosemaphore.exc_page_fault.asm_exc_page_fault
>       8.16           +37.2       45.40        perf-profile.calltrace.cycl=
es-pp.force_sig_fault.__bad_area_nosemaphore.exc_page_fault.asm_exc_page_fa=
ult
>       8.04           +37.3       45.39        perf-profile.calltrace.cycl=
es-pp.force_sig_info_to_task.force_sig_fault.__bad_area_nosemaphore.exc_pag=
e_fault.asm_exc_page_fault
>       6.53           +37.8       44.36        perf-profile.calltrace.cycl=
es-pp.get_signal.arch_do_signal_or_restart.exit_to_user_mode_prepare.irqent=
ry_exit_to_user_mode.asm_exc_page_fault
>       7.06           +38.0       45.05        perf-profile.calltrace.cycl=
es-pp.__send_signal.force_sig_info_to_task.force_sig_fault.__bad_area_nosem=
aphore.exc_page_fault
>       4.28 =C2=B1  2%     +39.2       43.46        perf-profile.calltrace=
.cycles-pp.__sigqueue_free.get_signal.arch_do_signal_or_restart.exit_to_use=
r_mode_prepare.irqentry_exit_to_user_mode
>       4.87 =C2=B1  2%     +39.9       44.81        perf-profile.calltrace=
.cycles-pp.__sigqueue_alloc.__send_signal.force_sig_info_to_task.force_sig_=
fault.__bad_area_nosemaphore
>       0.00           +42.7       42.72        perf-profile.calltrace.cycl=
es-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.put_ucounts._=
_sigqueue_free.get_signal
>       0.00           +43.0       42.99        perf-profile.calltrace.cycl=
es-pp._raw_spin_lock_irqsave.put_ucounts.__sigqueue_free.get_signal.arch_do=
_signal_or_restart
>       0.00           +43.1       43.08        perf-profile.calltrace.cycl=
es-pp.put_ucounts.__sigqueue_free.get_signal.arch_do_signal_or_restart.exit=
_to_user_mode_prepare
>       0.00           +43.5       43.52        perf-profile.calltrace.cycl=
es-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_ucounts._=
_sigqueue_alloc.__send_signal
>       0.00           +44.0       43.97        perf-profile.calltrace.cycl=
es-pp._raw_spin_lock_irqsave.get_ucounts.__sigqueue_alloc.__send_signal.for=
ce_sig_info_to_task
>       0.00           +44.1       44.05        perf-profile.calltrace.cycl=
es-pp.get_ucounts.__sigqueue_alloc.__send_signal.force_sig_info_to_task.for=
ce_sig_fault
>      31.89           +60.0       91.94        perf-profile.calltrace.cycl=
es-pp.asm_exc_page_fault
>      33.84           -29.7        4.10        perf-profile.children.cycle=
s-pp.entry_SYSCALL_64_after_hwframe
>      19.01           -16.5        2.48        perf-profile.children.cycle=
s-pp.syscall_exit_to_user_mode
>      14.93           -13.3        1.59        perf-profile.children.cycle=
s-pp.syscall_return_via_sysret
>      13.14           -11.7        1.43 =C2=B1  2%  perf-profile.children.=
cycles-pp.do_syscall_64
>      10.60            -9.3        1.27        perf-profile.children.cycle=
s-pp.__entry_text_start
>       6.17 =C2=B1  2%      -5.5        0.68 =C2=B1  2%  perf-profile.chil=
dren.cycles-pp.__x64_sys_rt_sigaction
>       5.55            -4.8        0.71 =C2=B1  2%  perf-profile.children.=
cycles-pp.__setup_rt_frame
>       3.63 =C2=B1  2%      -3.2        0.40 =C2=B1  2%  perf-profile.chil=
dren.cycles-pp.__x64_sys_rt_sigprocmask
>       3.54            -3.2        0.32 =C2=B1  4%  perf-profile.children.=
cycles-pp.entry_SYSCALL_64_safe_stack
>       3.11 =C2=B1  3%      -2.8        0.35 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp._copy_from_user
>       2.91            -2.5        0.37 =C2=B1  2%  perf-profile.children.=
cycles-pp.copy_fpstate_to_sigframe
>       2.38            -2.1        0.28        perf-profile.children.cycle=
s-pp.__irqentry_text_end
>       2.40 =C2=B1  4%      -2.1        0.30 =C2=B1  2%  perf-profile.chil=
dren.cycles-pp.__might_fault
>       2.23            -1.9        0.32        perf-profile.children.cycle=
s-pp.native_irq_return_iret
>       2.26 =C2=B1  2%      -1.9        0.35 =C2=B1  5%  perf-profile.chil=
dren.cycles-pp.do_user_addr_fault
>       1.86            -1.6        0.27 =C2=B1  3%  perf-profile.children.=
cycles-pp.do_sigaction
>       1.75            -1.5        0.21 =C2=B1  3%  perf-profile.children.=
cycles-pp.copy_user_generic_unrolled
>       1.67 =C2=B1  3%      -1.5        0.19 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp.__set_current_blocked
>       1.51 =C2=B1  2%      -1.3        0.18 =C2=B1  2%  perf-profile.chil=
dren.cycles-pp._raw_spin_lock_irq
>       1.33 =C2=B1  3%      -1.1        0.19        perf-profile.children.=
cycles-pp.copy_siginfo_to_user
>       1.24 =C2=B1  3%      -1.1        0.13 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp.recalc_sigpending
>       1.30 =C2=B1  4%      -1.1        0.18 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp._copy_to_user
>       1.23 =C2=B1  3%      -1.1        0.15 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp.___might_sleep
>       1.07 =C2=B1  4%      -0.9        0.12 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp.signal_setup_done
>       0.98 =C2=B1  4%      -0.9        0.11 =C2=B1  4%  perf-profile.chil=
dren.cycles-pp.fpu__clear
>       0.93 =C2=B1  4%      -0.8        0.12 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.__might_sleep
>       0.89            -0.8        0.14 =C2=B1  3%  perf-profile.children.=
cycles-pp.__clear_user
>       0.85 =C2=B1  4%      -0.7        0.10 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp.__set_task_blocked
>       0.81 =C2=B1  2%      -0.7        0.10 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.sigprocmask
>       0.76 =C2=B1 11%      -0.7        0.07 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.syscall_enter_from_user_mode
>       0.70 =C2=B1  2%      -0.6        0.06 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.signal_wake_up_state
>       0.73            -0.6        0.13 =C2=B1  7%  perf-profile.children.=
cycles-pp.__perf_sw_event
>       0.50 =C2=B1  2%      -0.5        0.04 =C2=B1 44%  perf-profile.chil=
dren.cycles-pp.complete_signal
>       0.50 =C2=B1  4%      -0.4        0.08 =C2=B1 11%  perf-profile.chil=
dren.cycles-pp.___perf_sw_event
>       0.45            -0.4        0.06 =C2=B1  6%  perf-profile.children.=
cycles-pp.sync_regs
>       0.44            -0.4        0.07 =C2=B1 10%  perf-profile.children.=
cycles-pp.fixup_vdso_exception
>       0.35 =C2=B1  2%      -0.3        0.05        perf-profile.children.=
cycles-pp.prepare_signal
>       0.35 =C2=B1  3%      -0.3        0.08 =C2=B1  5%  perf-profile.chil=
dren.cycles-pp.is_prefetch
>       0.33 =C2=B1 11%      -0.3        0.07 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.kmem_cache_alloc
>       0.19 =C2=B1  4%      -0.1        0.05 =C2=B1 45%  perf-profile.chil=
dren.cycles-pp.copy_from_kernel_nofault
>       0.33            +0.0        0.37 =C2=B1  3%  perf-profile.children.=
cycles-pp.kmem_cache_free
>       0.00            +0.4        0.36 =C2=B1  4%  perf-profile.children.=
cycles-pp.dec_rlimit_ucounts
>       0.00            +0.6        0.65        perf-profile.children.cycle=
s-pp.inc_rlimit_ucounts_and_test
>      19.11           +26.8       45.91        perf-profile.children.cycle=
s-pp.irqentry_exit_to_user_mode
>      15.69           +29.8       45.51        perf-profile.children.cycle=
s-pp.exit_to_user_mode_prepare
>      14.70           +30.7       45.38        perf-profile.children.cycle=
s-pp.arch_do_signal_or_restart
>      11.77           +34.2       45.99        perf-profile.children.cycle=
s-pp.exc_page_fault
>       8.90           +36.7       45.55        perf-profile.children.cycle=
s-pp.__bad_area_nosemaphore
>       8.17           +37.2       45.40        perf-profile.children.cycle=
s-pp.force_sig_fault
>       8.10           +37.3       45.39        perf-profile.children.cycle=
s-pp.force_sig_info_to_task
>       6.57           +37.8       44.38        perf-profile.children.cycle=
s-pp.get_signal
>       7.11           +38.0       45.06        perf-profile.children.cycle=
s-pp.__send_signal
>       4.28 =C2=B1  2%     +39.2       43.46        perf-profile.children.=
cycles-pp.__sigqueue_free
>       4.89 =C2=B1  2%     +39.9       44.82        perf-profile.children.=
cycles-pp.__sigqueue_alloc
>       0.00           +43.1       43.09        perf-profile.children.cycle=
s-pp.put_ucounts
>       0.00           +44.1       44.05        perf-profile.children.cycle=
s-pp.get_ucounts
>      31.95           +60.0       91.95        perf-profile.children.cycle=
s-pp.asm_exc_page_fault
>       0.00           +86.2       86.24        perf-profile.children.cycle=
s-pp.native_queued_spin_lock_slowpath
>       0.32 =C2=B1  4%     +86.7       87.01        perf-profile.children.=
cycles-pp._raw_spin_lock_irqsave
>      18.17           -15.8        2.36        perf-profile.self.cycles-pp=
.syscall_exit_to_user_mode
>      14.90           -13.3        1.58        perf-profile.self.cycles-pp=
.syscall_return_via_sysret
>      10.60            -9.3        1.27        perf-profile.self.cycles-pp=
.__entry_text_start
>       4.55 =C2=B1  2%      -4.5        0.04 =C2=B1 72%  perf-profile.self=
.cycles-pp.__sigqueue_alloc
>       4.09 =C2=B1  2%      -3.6        0.49 =C2=B1  2%  perf-profile.self=
.cycles-pp.irqentry_exit_to_user_mode
>       2.30 =C2=B1  5%      -2.1        0.19 =C2=B1  4%  perf-profile.self=
.cycles-pp.do_syscall_64
>       2.38            -2.1        0.28        perf-profile.self.cycles-pp=
.__irqentry_text_end
>       2.22            -1.9        0.32        perf-profile.self.cycles-pp=
.native_irq_return_iret
>       1.92 =C2=B1  8%      -1.8        0.16 =C2=B1  2%  perf-profile.self=
.cycles-pp.__x64_sys_rt_sigaction
>       1.72 =C2=B1  3%      -1.5        0.20 =C2=B1  5%  perf-profile.self=
.cycles-pp.entry_SYSCALL_64_after_hwframe
>       1.71            -1.5        0.21 =C2=B1  4%  perf-profile.self.cycl=
es-pp.copy_fpstate_to_sigframe
>       1.68            -1.5        0.20 =C2=B1  3%  perf-profile.self.cycl=
es-pp.copy_user_generic_unrolled
>       1.46 =C2=B1  4%      -1.3        0.12 =C2=B1  4%  perf-profile.self=
.cycles-pp.__x64_sys_rt_sigprocmask
>       1.46 =C2=B1  2%      -1.3        0.17 =C2=B1  3%  perf-profile.self=
.cycles-pp._raw_spin_lock_irq
>       1.21 =C2=B1  6%      -1.1        0.14 =C2=B1  5%  perf-profile.self=
.cycles-pp.__setup_rt_frame
>       1.21 =C2=B1  2%      -1.1        0.14 =C2=B1  3%  perf-profile.self=
.cycles-pp.___might_sleep
>       1.06 =C2=B1  4%      -1.0        0.09 =C2=B1  5%  perf-profile.self=
.cycles-pp.recalc_sigpending
>       1.01 =C2=B1  6%      -1.0        0.05        perf-profile.self.cycl=
es-pp.asm_exc_page_fault
>       0.97 =C2=B1  4%      -0.9        0.10 =C2=B1  7%  perf-profile.self=
.cycles-pp.entry_SYSCALL_64_safe_stack
>       0.95 =C2=B1  2%      -0.8        0.12 =C2=B1  4%  perf-profile.self=
.cycles-pp.exit_to_user_mode_prepare
>       0.98            -0.8        0.15 =C2=B1  4%  perf-profile.self.cycl=
es-pp.do_sigaction
>       0.84 =C2=B1  4%      -0.7        0.10 =C2=B1  6%  perf-profile.self=
.cycles-pp.__might_sleep
>       0.72 =C2=B1  8%      -0.6        0.09 =C2=B1  4%  perf-profile.self=
.cycles-pp._copy_from_user
>       0.71 =C2=B1  2%      -0.6        0.10 =C2=B1  7%  perf-profile.self=
.cycles-pp.do_user_addr_fault
>       0.65 =C2=B1 14%      -0.6        0.06 =C2=B1 11%  perf-profile.self=
.cycles-pp.syscall_enter_from_user_mode
>       0.68 =C2=B1  6%      -0.6        0.10 =C2=B1  3%  perf-profile.self=
.cycles-pp.__might_fault
>       0.80            -0.6        0.25 =C2=B1  3%  perf-profile.self.cycl=
es-pp.get_signal
>       0.64 =C2=B1  4%      -0.6        0.08 =C2=B1  5%  perf-profile.self=
.cycles-pp.fpu__clear
>       0.57 =C2=B1  3%      -0.5        0.07 =C2=B1  7%  perf-profile.self=
.cycles-pp.__send_signal
>       0.53 =C2=B1  2%      -0.5        0.08 =C2=B1  6%  perf-profile.self=
.cycles-pp.__clear_user
>       0.49 =C2=B1  5%      -0.4        0.04 =C2=B1 45%  perf-profile.self=
.cycles-pp.arch_do_signal_or_restart
>       0.43            -0.4        0.06 =C2=B1  7%  perf-profile.self.cycl=
es-pp.fixup_vdso_exception
>       0.42 =C2=B1  4%      -0.4        0.06 =C2=B1  7%  perf-profile.self=
.cycles-pp.___perf_sw_event
>       0.41            -0.4        0.05 =C2=B1  9%  perf-profile.self.cycl=
es-pp.sync_regs
>       0.33 =C2=B1  3%      -0.3        0.04 =C2=B1 44%  perf-profile.self=
.cycles-pp.prepare_signal
>       0.31 =C2=B1 12%      -0.2        0.07 =C2=B1  7%  perf-profile.self=
.cycles-pp.kmem_cache_alloc
>       0.22 =C2=B1  3%      -0.1        0.10 =C2=B1  7%  perf-profile.self=
.cycles-pp._raw_spin_unlock_irqrestore
>       0.33            +0.0        0.36 =C2=B1  3%  perf-profile.self.cycl=
es-pp.kmem_cache_free
>       0.00            +0.1        0.06 =C2=B1  9%  perf-profile.self.cycl=
es-pp.get_ucounts
>       0.00            +0.1        0.06 =C2=B1  6%  perf-profile.self.cycl=
es-pp.put_ucounts
>       0.00            +0.4        0.36 =C2=B1  4%  perf-profile.self.cycl=
es-pp.dec_rlimit_ucounts
>       0.27 =C2=B1  4%      +0.5        0.77 =C2=B1  2%  perf-profile.self=
.cycles-pp._raw_spin_lock_irqsave
>       0.00            +0.6        0.65        perf-profile.self.cycles-pp=
.inc_rlimit_ucounts_and_test
>       0.00           +86.2       86.24        perf-profile.self.cycles-pp=
.native_queued_spin_lock_slowpath
>
>
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>                              stress-ng.time.user_time=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>   1400 +-----------------------------------------------------------------=
---+=20=20=20
>        |.++.+.+.++.+.+.++.+.++.+.+.++.+.+.++.+.++.+.+.++.+.++.+.+. +.+.+.=
++.|=20=20=20
>   1200 |-+                                                        +      =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>   1000 |-+                                                               =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>    800 |-+                                                               =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>    600 |-+                                                               =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>    400 |-+      O                                                        =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>    200 |-OO O O  O O O OO O OO O O OO O O OO O OO O O OO O OO            =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>      0 +-----------------------------------------------------------------=
---+=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
>                             stress-ng.time.system_time=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>   2800 +-----------------------------------------------------------------=
---+=20=20=20
>        |             O         O O    O   OO    O   O O  O O             =
   |=20=20=20
>   2600 |-OO O O  O O   OO O OO     OO   O    O O  O    O    O            =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>   2400 |-+      O                                                        =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>   2200 |-+                                                               =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>   2000 |-+                                                               =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>   1800 |-+                                                               =
   |=20=20=20
>        |                                                                 =
   |=20=20=20
>   1600 |.++.+.+.++.+.    .+.++.+.+.++.+.+.++.+.++.+.+.++.+.+ .+.+.++.+.+.=
++.|=20=20=20
>        |             +.++                                   +            =
   |=20=20=20
>   1400 +-----------------------------------------------------------------=
---+=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
>                                  stress-ng.sigsegv.ops=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>     5e+08 +--------------------------------------------------------------=
---+=20=20=20
>           |.++.+.++.+.++.+.++.++.+.++.+.++.+.++.+.++.+.++.+.++.++.+.++.+.=
++.|=20=20=20
>   4.5e+08 |-+                                                            =
   |=20=20=20
>     4e+08 |-+                                                            =
   |=20=20=20
>           |                                                              =
   |=20=20=20
>   3.5e+08 |-+                                                            =
   |=20=20=20
>     3e+08 |-+                                                            =
   |=20=20=20
>           |                                                              =
   |=20=20=20
>   2.5e+08 |-+                                                            =
   |=20=20=20
>     2e+08 |-+                                                            =
   |=20=20=20
>           |                                                              =
   |=20=20=20
>   1.5e+08 |-+                                                            =
   |=20=20=20
>     1e+08 |-+                                                            =
   |=20=20=20
>           | OO O OO O OO O OO OO O OO O OO O OO O OO O OO O OO           =
   |=20=20=20
>     5e+07 +--------------------------------------------------------------=
---+=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
>                             stress-ng.sigsegv.ops_per_sec=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>   8e+06 +----------------------------------------------------------------=
---+=20=20=20
>         |                                                                =
   |=20=20=20
>   7e+06 |-+                                                              =
   |=20=20=20
>         |                                                                =
   |=20=20=20
>   6e+06 |-+                                                              =
   |=20=20=20
>         |                                                                =
   |=20=20=20
>   5e+06 |-+                                                              =
   |=20=20=20
>         |                                                                =
   |=20=20=20
>   4e+06 |-+                                                              =
   |=20=20=20
>         |                                                                =
   |=20=20=20
>   3e+06 |-+                                                              =
   |=20=20=20
>         |                                                                =
   |=20=20=20
>   2e+06 |-+                                                              =
   |=20=20=20
>         | OO O O OO O OO O OO O O OO O OO O OO O O OO O OO O O           =
   |=20=20=20
>   1e+06 +----------------------------------------------------------------=
---+=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
> [*] bisect-good sample
> [O] bisect-bad  sample
>
> *************************************************************************=
**************************
> lkp-ivb-2ep1: 48 threads Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 1=
12G memory
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> class/compiler/cpufreq_governor/disk/kconfig/nr_threads/rootfs/tbox_group=
/test/testcase/testtime/ucode:
>   interrupt/gcc-9/performance/1HDD/x86_64-rhel-8.3/100%/debian-10.4-x86_6=
4-20200603.cgz/lkp-ivb-2ep1/sigq/stress-ng/60s/0x42e
>
> commit:=20
>   4660d663b4 ("Reimplement RLIMIT_MSGQUEUE on top of ucounts")
>   d28296d248 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
>
> 4660d663b4207ce6 d28296d2484fa11e94dff65e93e=20
> ---------------- ---------------------------=20
>          %stddev     %change         %stddev
>              \          |                \=20=20
>  4.176e+08           -56.1%  1.831e+08 =C2=B1 21%  stress-ng.sigq.ops
>    6959423           -56.1%    3051857 =C2=B1 21%  stress-ng.sigq.ops_per=
_sec
>  2.157e+08 =C2=B1  8%     -66.1%   73100172 =C2=B1  9%  stress-ng.time.in=
voluntary_context_switches
>      14467            +1.4%      14674        stress-ng.time.minor_page_f=
aults
>       4513            +1.2%       4569        stress-ng.time.percent_of_c=
pu_this_job_got
>       2150           +17.9%       2535 =C2=B1  3%  stress-ng.time.system_=
time
>     660.96           -53.1%     309.96 =C2=B1 30%  stress-ng.time.user_ti=
me
>  2.478e+08 =C2=B1  5%     -70.5%   73168836 =C2=B1  9%  stress-ng.time.vo=
luntary_context_switches
>       7.70 =C2=B1  8%      -6.8%       7.18        iostat.cpu.idle
>      70.60           +16.6%      82.32 =C2=B1  3%  iostat.cpu.system
>      21.70           -51.6%      10.49 =C2=B1 29%  iostat.cpu.user
>      15660 =C2=B1  3%     +13.7%      17806 =C2=B1  3%  meminfo.Active
>      15660 =C2=B1  3%     +13.7%      17806 =C2=B1  3%  meminfo.Active(an=
on)
>      31878 =C2=B1  2%      +8.8%      34688 =C2=B1  2%  meminfo.Shmem
>     123900 =C2=B1 66%     -66.9%      41021 =C2=B1 30%  cpuidle.C1.usage
>  1.507e+08 =C2=B1  6%      +9.5%   1.65e+08 =C2=B1  4%  cpuidle.C6.time
>     681599 =C2=B1 38%     -72.8%     185137 =C2=B1113%  cpuidle.POLL.time
>     645871 =C2=B1 39%     -98.5%       9580 =C2=B1 75%  cpuidle.POLL.usage
>       1.78 =C2=B1  3%      -0.8        0.95        mpstat.cpu.all.irq%
>       0.03 =C2=B1  4%      -0.0        0.02 =C2=B1 27%  mpstat.cpu.all.so=
ft%
>      70.90           +12.5       83.42 =C2=B1  3%  mpstat.cpu.all.sys%
>      22.35           -11.6       10.75 =C2=B1 29%  mpstat.cpu.all.usr%
>     825.33 =C2=B1  2%     -11.6%     729.67 =C2=B1  5%  slabinfo.file_loc=
k_cache.active_objs
>     825.33 =C2=B1  2%     -11.6%     729.67 =C2=B1  5%  slabinfo.file_loc=
k_cache.num_objs
>       1455 =C2=B1 11%     -32.4%     983.00 =C2=B1 13%  slabinfo.khugepag=
ed_mm_slot.active_objs
>       1455 =C2=B1 11%     -32.4%     983.00 =C2=B1 13%  slabinfo.khugepag=
ed_mm_slot.num_objs
>      69.67           +17.2%      81.67 =C2=B1  3%  vmstat.cpu.sy
>      21.00           -52.4%      10.00 =C2=B1 29%  vmstat.cpu.us
>    7139282 =C2=B1  7%     -68.5%    2251603 =C2=B1  9%  vmstat.system.cs
>     518916 =C2=B1  6%     -80.5%     101139 =C2=B1  4%  vmstat.system.in
>       8082 =C2=B1 51%     -68.3%       2565 =C2=B1 17%  softirqs.CPU10.SC=
HED
>       6261 =C2=B1 72%     -56.4%       2729 =C2=B1 14%  softirqs.CPU17.SC=
HED
>       6147 =C2=B1 66%     -64.3%       2195 =C2=B1  3%  softirqs.CPU25.SC=
HED
>      16334 =C2=B1 41%     -82.6%       2846 =C2=B1 24%  softirqs.CPU27.SC=
HED
>       6280 =C2=B1 56%     -61.9%       2394 =C2=B1  9%  softirqs.CPU39.SC=
HED
>       8248 =C2=B1 50%     -73.2%       2209 =C2=B1  8%  softirqs.CPU40.SC=
HED
>     228327 =C2=B1  9%     -46.3%     122665 =C2=B1  2%  softirqs.SCHED
>       3851 =C2=B1  4%     +13.8%       4381 =C2=B1  4%  proc-vmstat.nr_ac=
tive_anon
>       9587            +2.8%       9855        proc-vmstat.nr_mapped
>       7943 =C2=B1  2%      +8.7%       8630 =C2=B1  2%  proc-vmstat.nr_sh=
mem
>       3851 =C2=B1  4%     +13.8%       4381 =C2=B1  4%  proc-vmstat.nr_zo=
ne_active_anon
>     438.33 =C2=B1122%   +1463.6%       6853 =C2=B1 69%  proc-vmstat.numa_=
pages_migrated
>       8816 =C2=B1  4%     +11.5%       9827 =C2=B1  6%  proc-vmstat.pgact=
ivate
>     291848            +1.7%     296689        proc-vmstat.pgalloc_normal
>     438.33 =C2=B1122%   +1463.6%       6853 =C2=B1 69%  proc-vmstat.pgmig=
rate_success
>     252.00 =C2=B1 19%     +30.8%     329.67 =C2=B1  7%  numa-vmstat.node0=
.nr_active_anon
>      44373 =C2=B1 23%     -64.0%      15967 =C2=B1 49%  numa-vmstat.node0=
.nr_anon_pages
>      46179 =C2=B1 21%     -61.8%      17619 =C2=B1 38%  numa-vmstat.node0=
.nr_inactive_anon
>     252.00 =C2=B1 19%     +30.8%     329.67 =C2=B1  7%  numa-vmstat.node0=
.nr_zone_active_anon
>      46179 =C2=B1 21%     -61.8%      17619 =C2=B1 38%  numa-vmstat.node0=
.nr_zone_inactive_anon
>       3678 =C2=B1  4%     +11.5%       4100 =C2=B1  4%  numa-vmstat.node1=
.nr_active_anon
>      13880 =C2=B1 74%    +206.7%      42565 =C2=B1 17%  numa-vmstat.node1=
.nr_anon_pages
>      16004 =C2=B1 59%    +181.1%      44988 =C2=B1 14%  numa-vmstat.node1=
.nr_inactive_anon
>       3678 =C2=B1  4%     +11.5%       4100 =C2=B1  4%  numa-vmstat.node1=
.nr_zone_active_anon
>      16004 =C2=B1 59%    +181.1%      44988 =C2=B1 14%  numa-vmstat.node1=
.nr_zone_inactive_anon
>       1007 =C2=B1 19%     +31.3%       1322 =C2=B1  7%  numa-meminfo.node=
0.Active
>       1007 =C2=B1 19%     +31.3%       1322 =C2=B1  7%  numa-meminfo.node=
0.Active(anon)
>      39280 =C2=B1 35%     -66.1%      13314 =C2=B1 74%  numa-meminfo.node=
0.AnonHugePages
>     177224 =C2=B1 24%     -63.9%      63933 =C2=B1 49%  numa-meminfo.node=
0.AnonPages
>     182948 =C2=B1 22%     -52.3%      87286 =C2=B1 59%  numa-meminfo.node=
0.AnonPages.max
>     184457 =C2=B1 21%     -61.8%      70532 =C2=B1 38%  numa-meminfo.node=
0.Inactive
>     184457 =C2=B1 21%     -61.8%      70532 =C2=B1 38%  numa-meminfo.node=
0.Inactive(anon)
>    1080630 =C2=B1  5%     -12.3%     947332 =C2=B1  3%  numa-meminfo.node=
0.MemUsed
>      14267 =C2=B1  4%     +17.0%      16695 =C2=B1  5%  numa-meminfo.node=
1.Active
>      14267 =C2=B1  4%     +17.0%      16695 =C2=B1  5%  numa-meminfo.node=
1.Active(anon)
>      56124 =C2=B1 74%    +202.8%     169963 =C2=B1 17%  numa-meminfo.node=
1.AnonPages
>      75025 =C2=B1 56%    +139.7%     179816 =C2=B1 14%  numa-meminfo.node=
1.AnonPages.max
>      64951 =C2=B1 59%    +176.3%     179452 =C2=B1 14%  numa-meminfo.node=
1.Inactive
>      64951 =C2=B1 59%    +176.3%     179452 =C2=B1 14%  numa-meminfo.node=
1.Inactive(anon)
>     941178 =C2=B1  5%     +14.6%    1078500 =C2=B1  3%  numa-meminfo.node=
1.MemUsed
>      51.14 =C2=B1 15%     +47.4%      75.37 =C2=B1 13%  sched_debug.cfs_r=
q:/.load_avg.avg
>     114.91 =C2=B1 14%     +38.2%     158.79 =C2=B1 13%  sched_debug.cfs_r=
q:/.load_avg.stddev
>       6.99 =C2=B1 70%    +352.8%      31.65 =C2=B1 27%  sched_debug.cfs_r=
q:/.removed.load_avg.avg
>      47.92 =C2=B1 70%    +153.1%     121.29 =C2=B1 12%  sched_debug.cfs_r=
q:/.removed.load_avg.stddev
>       2.38 =C2=B1 97%    +182.8%       6.74 =C2=B1 36%  sched_debug.cfs_r=
q:/.removed.runnable_avg.avg
>       2.38 =C2=B1 97%    +182.7%       6.73 =C2=B1 36%  sched_debug.cfs_r=
q:/.removed.util_avg.avg
>     356.50 =C2=B1  3%     -24.1%     270.50 =C2=B1 31%  sched_debug.cfs_r=
q:/.util_avg.min
>     290.54 =C2=B1  2%     +10.6%     321.30 =C2=B1  5%  sched_debug.cfs_r=
q:/.util_est_enqueued.avg
>     446696 =C2=B1  4%     +50.1%     670473 =C2=B1  7%  sched_debug.cpu.a=
vg_idle.avg
>    1120651 =C2=B1 11%     +20.5%    1350114 =C2=B1 10%  sched_debug.cpu.a=
vg_idle.max
>       2124 =C2=B1 10%     +43.0%       3038 =C2=B1 15%  sched_debug.cpu.a=
vg_idle.min
>     708.23 =C2=B1  3%     -14.4%     606.42 =C2=B1  4%  sched_debug.cpu.c=
lock_task.stddev
>     989.50 =C2=B1  8%     +12.0%       1108        sched_debug.cpu.curr->=
pid.min
>      21503 =C2=B1 71%    +114.0%      46014 =C2=B1 39%  sched_debug.cpu.m=
ax_idle_balance_cost.stddev
>    4583665 =C2=B1  7%     -68.5%    1443748 =C2=B1  9%  sched_debug.cpu.n=
r_switches.avg
>    6508139 =C2=B1  3%     -71.5%    1854831        sched_debug.cpu.nr_swi=
tches.max
>    2183394 =C2=B1 28%     -83.2%     367194 =C2=B1 87%  sched_debug.cpu.n=
r_switches.min
>    1135976 =C2=B1 11%     -69.9%     342489 =C2=B1 34%  sched_debug.cpu.n=
r_switches.stddev
>       0.03 =C2=B1 59%    -100.0%       0.00        perf-sched.sch_delay.a=
vg.ms.__sched_text_start.__sched_text_start.do_syslog.part.0
>       0.01 =C2=B1 12%     -36.4%       0.00 =C2=B1 26%  perf-sched.sch_de=
lay.avg.ms.__sched_text_start.__sched_text_start.exit_to_user_mode_prepare.=
syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
>       0.05 =C2=B1 57%    -100.0%       0.00        perf-sched.sch_delay.m=
ax.ms.__sched_text_start.__sched_text_start.do_syslog.part.0
>       0.19 =C2=B1 77%     -61.0%       0.07 =C2=B1  5%  perf-sched.sch_de=
lay.max.ms.__sched_text_start.__sched_text_start.pipe_read.new_sync_read.vf=
s_read
>       7.83 =C2=B1140%     -99.8%       0.01 =C2=B1 38%  perf-sched.sch_de=
lay.max.ms.__sched_text_start.__sched_text_start.smpboot_thread_fn.kthread.=
ret_from_fork
>       0.36 =C2=B1 18%     -64.4%       0.13 =C2=B1 75%  perf-sched.total_=
wait_and_delay.average.ms
>       0.24 =C2=B1  5%     -72.2%       0.07 =C2=B1 66%  perf-sched.total_=
wait_time.average.ms
>       1.38 =C2=B1  6%    -100.0%       0.00        perf-sched.wait_and_de=
lay.avg.ms.__sched_text_start.__sched_text_start.do_syslog.part.0
>       0.03 =C2=B1 41%     -61.6%       0.01 =C2=B1 80%  perf-sched.wait_a=
nd_delay.avg.ms.__sched_text_start.__sched_text_start.do_task_dead.do_exit.=
do_group_exit
>       0.01 =C2=B1 12%     -36.4%       0.00 =C2=B1 26%  perf-sched.wait_a=
nd_delay.avg.ms.__sched_text_start.__sched_text_start.exit_to_user_mode_pre=
pare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
>       0.08 =C2=B1 17%     -30.3%       0.05 =C2=B1  3%  perf-sched.wait_a=
nd_delay.avg.ms.__sched_text_start.__sched_text_start.pipe_read.new_sync_re=
ad.vfs_read
>       2.00          -100.0%       0.00        perf-sched.wait_and_delay.c=
ount.__sched_text_start.__sched_text_start.do_syslog.part.0
>       9.00           -81.5%       1.67 =C2=B1 28%  perf-sched.wait_and_de=
lay.count.__sched_text_start.__sched_text_start.schedule_timeout.rcu_gp_kth=
read.kthread
>       2.72 =C2=B1  8%    -100.0%       0.00        perf-sched.wait_and_de=
lay.max.ms.__sched_text_start.__sched_text_start.do_syslog.part.0
>       0.80 =C2=B1 45%     -89.3%       0.09 =C2=B1 10%  perf-sched.wait_a=
nd_delay.max.ms.__sched_text_start.__sched_text_start.pipe_read.new_sync_re=
ad.vfs_read
>       7.83 =C2=B1140%     -99.8%       0.01 =C2=B1 38%  perf-sched.wait_a=
nd_delay.max.ms.__sched_text_start.__sched_text_start.smpboot_thread_fn.kth=
read.ret_from_fork
>       1.35 =C2=B1  8%    -100.0%       0.00        perf-sched.wait_time.a=
vg.ms.__sched_text_start.__sched_text_start.do_syslog.part.0
>       0.03 =C2=B1 42%     -66.3%       0.01 =C2=B1 82%  perf-sched.wait_t=
ime.avg.ms.__sched_text_start.__sched_text_start.do_task_dead.do_exit.do_gr=
oup_exit
>       0.07 =C2=B1 24%     -27.6%       0.05 =C2=B1  3%  perf-sched.wait_t=
ime.avg.ms.__sched_text_start.__sched_text_start.pipe_read.new_sync_read.vf=
s_read
>       3.21 =C2=B1  2%     -58.6%       1.33 =C2=B1 70%  perf-sched.wait_t=
ime.avg.ms.__sched_text_start.__sched_text_start.schedule_timeout.rcu_gp_kt=
hread.kthread
>       2.69 =C2=B1  8%    -100.0%       0.00        perf-sched.wait_time.m=
ax.ms.__sched_text_start.__sched_text_start.do_syslog.part.0
>       0.77 =C2=B1 50%     -89.7%       0.08 =C2=B1 10%  perf-sched.wait_t=
ime.max.ms.__sched_text_start.__sched_text_start.pipe_read.new_sync_read.vf=
s_read
>       6.12 =C2=B1  3%     -27.9%       4.42 =C2=B1  3%  perf-stat.i.MPKI
>  1.008e+10 =C2=B1  4%     -20.8%  7.989e+09 =C2=B1  2%  perf-stat.i.branc=
h-instructions
>       1.55 =C2=B1  2%      -0.7        0.89        perf-stat.i.branch-mis=
s-rate%
>  1.372e+08 =C2=B1  2%     -60.4%   54290819        perf-stat.i.branch-mis=
ses
>       5.24 =C2=B1  7%      +6.4       11.66 =C2=B1  5%  perf-stat.i.cache=
-miss-rate%
>   12610881 =C2=B1  8%     +30.8%   16498692 =C2=B1  4%  perf-stat.i.cache=
-misses
>  2.994e+08           -50.1%  1.495e+08 =C2=B1  2%  perf-stat.i.cache-refe=
rences
>    7370989 =C2=B1  7%     -68.6%    2316288 =C2=B1  9%  perf-stat.i.conte=
xt-switches
>       2.75 =C2=B1  4%     +37.7%       3.78 =C2=B1  2%  perf-stat.i.cpi
>      37935 =C2=B1 20%     -99.1%     344.33 =C2=B1 39%  perf-stat.i.cpu-m=
igrations
>      10857 =C2=B1  9%     -24.6%       8184 =C2=B1  4%  perf-stat.i.cycle=
s-between-cache-misses
>       1.33 =C2=B1  4%      -0.5        0.81 =C2=B1 15%  perf-stat.i.dTLB-=
load-miss-rate%
>  1.921e+08 =C2=B1  3%     -59.4%   78058438 =C2=B1 14%  perf-stat.i.dTLB-=
load-misses
>  1.375e+10 =C2=B1  4%     -32.6%   9.26e+09        perf-stat.i.dTLB-loads
>       0.51 =C2=B1  5%      +0.1        0.61 =C2=B1  9%  perf-stat.i.dTLB-=
store-miss-rate%
>   52874010           -55.6%   23456497 =C2=B1 13%  perf-stat.i.dTLB-store=
-misses
>  9.955e+09 =C2=B1  3%     -63.0%  3.687e+09 =C2=B1  4%  perf-stat.i.dTLB-=
stores
>   62946854 =C2=B1  4%     -59.7%   25392611 =C2=B1  3%  perf-stat.i.iTLB-=
load-misses
>   4.88e+10 =C2=B1  4%     -28.0%  3.514e+10        perf-stat.i.instructio=
ns
>       1071           +54.5%       1655 =C2=B1 10%  perf-stat.i.instructio=
ns-per-iTLB-miss
>       0.38 =C2=B1  3%     -26.8%       0.28 =C2=B1  3%  perf-stat.i.ipc
>       0.52 =C2=B1  7%     -70.6%       0.15 =C2=B1 11%  perf-stat.i.metri=
c.K/sec
>     711.88 =C2=B1  3%     -38.1%     440.48        perf-stat.i.metric.M/s=
ec
>      47.42            -1.7       45.75        perf-stat.i.node-load-miss-=
rate%
>    3468825 =C2=B1 20%    +118.3%    7571866 =C2=B1  5%  perf-stat.i.node-=
load-misses
>    3747717 =C2=B1 20%    +133.9%    8764955 =C2=B1  4%  perf-stat.i.node-=
loads
>      47.67            -2.6       45.11        perf-stat.i.node-store-miss=
-rate%
>    8290895 =C2=B1  4%     -28.2%    5954593 =C2=B1  6%  perf-stat.i.node-=
store-misses
>    8800840           -19.9%    7053271 =C2=B1  5%  perf-stat.i.node-stores
>       6.14 =C2=B1  3%     -30.8%       4.25        perf-stat.overall.MPKI
>       1.36 =C2=B1  2%      -0.7        0.68        perf-stat.overall.bran=
ch-miss-rate%
>       4.22 =C2=B1 10%      +6.8       11.05 =C2=B1  6%  perf-stat.overall=
.cache-miss-rate%
>       2.79 =C2=B1  4%     +38.7%       3.87        perf-stat.overall.cpi
>      10868 =C2=B1  8%     -23.9%       8267 =C2=B1  4%  perf-stat.overall=
.cycles-between-cache-misses
>       1.38 =C2=B1  4%      -0.5        0.84 =C2=B1 15%  perf-stat.overall=
.dTLB-load-miss-rate%
>       0.53 =C2=B1  5%      +0.1        0.63 =C2=B1  8%  perf-stat.overall=
.dTLB-store-miss-rate%
>     775.35           +78.9%       1386 =C2=B1  5%  perf-stat.overall.inst=
ructions-per-iTLB-miss
>       0.36 =C2=B1  4%     -28.0%       0.26        perf-stat.overall.ipc
>      48.07            -1.7       46.34        perf-stat.overall.node-load=
-miss-rate%
>      48.49            -2.7       45.76        perf-stat.overall.node-stor=
e-miss-rate%
>  9.922e+09 =C2=B1  4%     -20.8%  7.859e+09 =C2=B1  2%  perf-stat.ps.bran=
ch-instructions
>  1.351e+08 =C2=B1  2%     -60.4%   53438494        perf-stat.ps.branch-mi=
sses
>   12410866 =C2=B1  8%     +30.8%   16234283 =C2=B1  4%  perf-stat.ps.cach=
e-misses
>  2.946e+08           -50.1%   1.47e+08 =C2=B1  2%  perf-stat.ps.cache-ref=
erences
>    7252050 =C2=B1  7%     -68.6%    2278311 =C2=B1  9%  perf-stat.ps.cont=
ext-switches
>      37323 =C2=B1 20%     -99.1%     338.80 =C2=B1 39%  perf-stat.ps.cpu-=
migrations
>   1.89e+08 =C2=B1  3%     -59.4%   76787292 =C2=B1 14%  perf-stat.ps.dTLB=
-load-misses
>  1.352e+10 =C2=B1  4%     -32.6%   9.11e+09        perf-stat.ps.dTLB-loads
>   52020930           -55.6%   23075080 =C2=B1 13%  perf-stat.ps.dTLB-stor=
e-misses
>  9.794e+09 =C2=B1  3%     -63.0%  3.627e+09 =C2=B1  4%  perf-stat.ps.dTLB=
-stores
>   61931461 =C2=B1  4%     -59.7%   24978175 =C2=B1  3%  perf-stat.ps.iTLB=
-load-misses
>  4.802e+10 =C2=B1  4%     -28.0%  3.457e+10        perf-stat.ps.instructi=
ons
>    3412948 =C2=B1 20%    +118.2%    7448345 =C2=B1  5%  perf-stat.ps.node=
-load-misses
>    3687448 =C2=B1 20%    +133.8%    8622075 =C2=B1  4%  perf-stat.ps.node=
-loads
>    8157655 =C2=B1  4%     -28.2%    5857930 =C2=B1  6%  perf-stat.ps.node=
-store-misses
>    8659916           -19.9%    6939197 =C2=B1  5%  perf-stat.ps.node-stor=
es
>  3.035e+12 =C2=B1  4%     -27.9%  2.189e+12        perf-stat.total.instru=
ctions
>      82.33 =C2=B1 64%   +1322.3%       1171 =C2=B1127%  interrupts.36:PCI=
-MSI.2621442-edge.eth0-TxRx-1
>   17959753 =C2=B1  6%     -99.7%      45889 =C2=B1  2%  interrupts.CAL:Fu=
nction_call_interrupts
>     103593 =C2=B1125%     -99.5%     569.33 =C2=B1  9%  interrupts.CPU0.C=
AL:Function_call_interrupts
>      45339 =C2=B1104%     -94.7%       2414 =C2=B1 30%  interrupts.CPU0.R=
ES:Rescheduling_interrupts
>    1078794 =C2=B1112%     -99.9%       1002 =C2=B1 12%  interrupts.CPU1.C=
AL:Function_call_interrupts
>       6507 =C2=B1 26%     +21.7%       7922 =C2=B1  6%  interrupts.CPU1.N=
MI:Non-maskable_interrupts
>       6507 =C2=B1 26%     +21.7%       7922 =C2=B1  6%  interrupts.CPU1.P=
MI:Performance_monitoring_interrupts
>     505526 =C2=B1101%     -99.8%       1223 =C2=B1 46%  interrupts.CPU1.R=
ES:Rescheduling_interrupts
>     791738 =C2=B1 80%     -99.9%     898.67 =C2=B1 13%  interrupts.CPU10.=
CAL:Function_call_interrupts
>     406363 =C2=B1 71%     -99.4%       2378 =C2=B1 80%  interrupts.CPU10.=
RES:Rescheduling_interrupts
>      46401 =C2=B1115%     -98.3%     789.00 =C2=B1 21%  interrupts.CPU11.=
CAL:Function_call_interrupts
>       5509 =C2=B1 35%     +25.8%       6931 =C2=B1 28%  interrupts.CPU11.=
NMI:Non-maskable_interrupts
>       5509 =C2=B1 35%     +25.8%       6931 =C2=B1 28%  interrupts.CPU11.=
PMI:Performance_monitoring_interrupts
>      27829 =C2=B1104%     -87.3%       3526 =C2=B1 77%  interrupts.CPU11.=
RES:Rescheduling_interrupts
>     290182 =C2=B1130%     -99.6%       1299 =C2=B1 24%  interrupts.CPU12.=
CAL:Function_call_interrupts
>     170757 =C2=B1136%     -98.3%       2886 =C2=B1 40%  interrupts.CPU12.=
RES:Rescheduling_interrupts
>     131940 =C2=B1 43%     -99.1%       1206 =C2=B1 37%  interrupts.CPU13.=
CAL:Function_call_interrupts
>      68303 =C2=B1 32%     -97.9%       1445 =C2=B1126%  interrupts.CPU13.=
RES:Rescheduling_interrupts
>     241043 =C2=B1116%     -99.5%       1319 =C2=B1 32%  interrupts.CPU14.=
CAL:Function_call_interrupts
>      98573 =C2=B1 93%     -97.0%       3005 =C2=B1 47%  interrupts.CPU14.=
RES:Rescheduling_interrupts
>     874074 =C2=B1 72%     -99.9%     875.33 =C2=B1  6%  interrupts.CPU15.=
CAL:Function_call_interrupts
>     350120 =C2=B1 49%     -99.9%     412.67 =C2=B1 52%  interrupts.CPU15.=
RES:Rescheduling_interrupts
>     577696 =C2=B1 23%     -99.9%     855.33 =C2=B1  3%  interrupts.CPU16.=
CAL:Function_call_interrupts
>       8263           -24.9%       6202 =C2=B1 23%  interrupts.CPU16.NMI:N=
on-maskable_interrupts
>       8263           -24.9%       6202 =C2=B1 23%  interrupts.CPU16.PMI:P=
erformance_monitoring_interrupts
>     237815 =C2=B1 15%     -99.5%       1220 =C2=B1 53%  interrupts.CPU16.=
RES:Rescheduling_interrupts
>     686797 =C2=B1112%     -99.9%     933.67 =C2=B1 13%  interrupts.CPU17.=
CAL:Function_call_interrupts
>     317108 =C2=B1105%     -99.8%     536.00 =C2=B1 49%  interrupts.CPU17.=
RES:Rescheduling_interrupts
>     748163 =C2=B1122%     -99.9%     863.00 =C2=B1  5%  interrupts.CPU18.=
CAL:Function_call_interrupts
>     320920 =C2=B1112%     -99.5%       1469 =C2=B1 95%  interrupts.CPU18.=
RES:Rescheduling_interrupts
>     286835 =C2=B1121%     -99.7%     943.33 =C2=B1 15%  interrupts.CPU19.=
CAL:Function_call_interrupts
>     174455 =C2=B1113%     -98.7%       2326 =C2=B1 69%  interrupts.CPU19.=
RES:Rescheduling_interrupts
>     443377 =C2=B1 83%     -99.8%     944.33 =C2=B1 12%  interrupts.CPU2.C=
AL:Function_call_interrupts
>      57297 =C2=B1 99%     -98.5%     855.00 =C2=B1  6%  interrupts.CPU20.=
CAL:Function_call_interrupts
>      54090 =C2=B1 67%     -99.0%     535.33 =C2=B1 74%  interrupts.CPU20.=
RES:Rescheduling_interrupts
>      27584 =C2=B1 80%     -96.8%     890.33 =C2=B1  6%  interrupts.CPU21.=
CAL:Function_call_interrupts
>      27052 =C2=B1 82%     -94.3%       1539 =C2=B1 58%  interrupts.CPU21.=
RES:Rescheduling_interrupts
>      62804 =C2=B1104%     -97.8%       1362 =C2=B1 47%  interrupts.CPU22.=
CAL:Function_call_interrupts
>      27230 =C2=B1 84%     -92.6%       2002 =C2=B1 86%  interrupts.CPU22.=
RES:Rescheduling_interrupts
>     351930 =C2=B1 72%     -99.7%     966.00 =C2=B1 16%  interrupts.CPU23.=
CAL:Function_call_interrupts
>     136149 =C2=B1 62%     -98.1%       2565 =C2=B1 93%  interrupts.CPU23.=
RES:Rescheduling_interrupts
>     366644 =C2=B1138%     -99.8%     877.67 =C2=B1  5%  interrupts.CPU24.=
CAL:Function_call_interrupts
>     499203 =C2=B1 82%     -99.8%     862.33 =C2=B1  3%  interrupts.CPU25.=
CAL:Function_call_interrupts
>     298172 =C2=B1 70%     -99.2%       2317 =C2=B1 19%  interrupts.CPU25.=
RES:Rescheduling_interrupts
>      11844 =C2=B1 61%     -92.9%     838.33 =C2=B1  2%  interrupts.CPU26.=
CAL:Function_call_interrupts
>      82.33 =C2=B1 64%   +1322.3%       1171 =C2=B1127%  interrupts.CPU27.=
36:PCI-MSI.2621442-edge.eth0-TxRx-1
>    1841110 =C2=B1 49%    -100.0%     746.33 =C2=B1 26%  interrupts.CPU27.=
CAL:Function_call_interrupts
>       5501 =C2=B1 35%     +25.6%       6909 =C2=B1 28%  interrupts.CPU27.=
NMI:Non-maskable_interrupts
>       5501 =C2=B1 35%     +25.6%       6909 =C2=B1 28%  interrupts.CPU27.=
PMI:Performance_monitoring_interrupts
>    1089819 =C2=B1 55%     -99.8%       1727 =C2=B1 80%  interrupts.CPU27.=
RES:Rescheduling_interrupts
>      74718 =C2=B1118%     -98.7%     942.00        interrupts.CPU28.CAL:F=
unction_call_interrupts
>       5504 =C2=B1 35%     +25.6%       6912 =C2=B1 28%  interrupts.CPU28.=
NMI:Non-maskable_interrupts
>       5504 =C2=B1 35%     +25.6%       6912 =C2=B1 28%  interrupts.CPU28.=
PMI:Performance_monitoring_interrupts
>      67380 =C2=B1125%     -98.5%       1034 =C2=B1 37%  interrupts.CPU28.=
RES:Rescheduling_interrupts
>     367428 =C2=B1 77%     -99.7%       1054 =C2=B1 22%  interrupts.CPU29.=
CAL:Function_call_interrupts
>     239038 =C2=B1 82%     -99.3%       1767 =C2=B1 84%  interrupts.CPU29.=
RES:Rescheduling_interrupts
>     220744 =C2=B1117%     -99.5%       1046 =C2=B1 21%  interrupts.CPU3.C=
AL:Function_call_interrupts
>     191269 =C2=B1119%     -98.4%       3122 =C2=B1 15%  interrupts.CPU3.R=
ES:Rescheduling_interrupts
>     247241 =C2=B1 81%     -99.6%     874.33 =C2=B1  5%  interrupts.CPU30.=
CAL:Function_call_interrupts
>     161878 =C2=B1 84%     -98.1%       3063 =C2=B1 37%  interrupts.CPU30.=
RES:Rescheduling_interrupts
>     144713 =C2=B1110%     -99.3%       1077 =C2=B1 23%  interrupts.CPU31.=
CAL:Function_call_interrupts
>       5502 =C2=B1 35%     +25.6%       6911 =C2=B1 28%  interrupts.CPU31.=
NMI:Non-maskable_interrupts
>       5502 =C2=B1 35%     +25.6%       6911 =C2=B1 28%  interrupts.CPU31.=
PMI:Performance_monitoring_interrupts
>      84227 =C2=B1100%     -96.4%       3013 =C2=B1 72%  interrupts.CPU31.=
RES:Rescheduling_interrupts
>     104510 =C2=B1109%     -99.2%     848.00 =C2=B1  4%  interrupts.CPU32.=
CAL:Function_call_interrupts
>       5515 =C2=B1 35%     +31.4%       7249 =C2=B1 20%  interrupts.CPU32.=
NMI:Non-maskable_interrupts
>       5515 =C2=B1 35%     +31.4%       7249 =C2=B1 20%  interrupts.CPU32.=
PMI:Performance_monitoring_interrupts
>      70068 =C2=B1101%     -96.7%       2320 =C2=B1126%  interrupts.CPU32.=
RES:Rescheduling_interrupts
>      87671 =C2=B1131%     -99.0%     857.33 =C2=B1  2%  interrupts.CPU33.=
CAL:Function_call_interrupts
>      35054 =C2=B1127%     -96.5%       1242 =C2=B1 80%  interrupts.CPU33.=
RES:Rescheduling_interrupts
>      77336 =C2=B1124%     -98.7%     988.33 =C2=B1 21%  interrupts.CPU34.=
CAL:Function_call_interrupts
>      66106 =C2=B1123%     -96.0%       2630 =C2=B1 52%  interrupts.CPU34.=
RES:Rescheduling_interrupts
>     136901 =C2=B1122%     -99.1%       1278 =C2=B1 30%  interrupts.CPU35.=
CAL:Function_call_interrupts
>     731054 =C2=B1 69%     -99.9%       1046 =C2=B1 15%  interrupts.CPU36.=
CAL:Function_call_interrupts
>     376136 =C2=B1 70%     -99.6%       1429 =C2=B1 37%  interrupts.CPU36.=
RES:Rescheduling_interrupts
>     941442 =C2=B1105%     -99.9%     851.33 =C2=B1  7%  interrupts.CPU37.=
CAL:Function_call_interrupts
>     300885 =C2=B1 80%     -99.2%       2379 =C2=B1 57%  interrupts.CPU37.=
RES:Rescheduling_interrupts
>     242878 =C2=B1117%     -99.6%     995.00 =C2=B1 16%  interrupts.CPU38.=
CAL:Function_call_interrupts
>     702836 =C2=B1 69%     -99.9%     855.00 =C2=B1  3%  interrupts.CPU39.=
CAL:Function_call_interrupts
>     286450 =C2=B1 74%     -99.5%       1448 =C2=B1 70%  interrupts.CPU39.=
RES:Rescheduling_interrupts
>      37564 =C2=B1 55%     -96.0%       1505 =C2=B1 62%  interrupts.CPU4.C=
AL:Function_call_interrupts
>       6346 =C2=B1 26%     +24.0%       7870 =C2=B1  6%  interrupts.CPU4.N=
MI:Non-maskable_interrupts
>       6346 =C2=B1 26%     +24.0%       7870 =C2=B1  6%  interrupts.CPU4.P=
MI:Performance_monitoring_interrupts
>      24154 =C2=B1 65%     -94.0%       1444 =C2=B1 83%  interrupts.CPU4.R=
ES:Rescheduling_interrupts
>     977103 =C2=B1 53%     -99.9%     837.33 =C2=B1  3%  interrupts.CPU40.=
CAL:Function_call_interrupts
>     512103 =C2=B1 71%     -99.7%       1579 =C2=B1 66%  interrupts.CPU40.=
RES:Rescheduling_interrupts
>     190023 =C2=B1117%     -99.6%     818.67 =C2=B1  2%  interrupts.CPU41.=
CAL:Function_call_interrupts
>     346179 =C2=B1 54%     -99.8%     829.00 =C2=B1  2%  interrupts.CPU42.=
CAL:Function_call_interrupts
>     183103 =C2=B1 48%     -99.5%     850.00 =C2=B1 54%  interrupts.CPU42.=
RES:Rescheduling_interrupts
>     371814 =C2=B1131%     -99.8%     863.33 =C2=B1  5%  interrupts.CPU43.=
CAL:Function_call_interrupts
>     158123 =C2=B1124%     -99.2%       1224 =C2=B1 71%  interrupts.CPU43.=
RES:Rescheduling_interrupts
>     578077 =C2=B1 61%     -99.9%     850.67 =C2=B1  3%  interrupts.CPU44.=
CAL:Function_call_interrupts
>     331471 =C2=B1 53%     -99.7%       1120 =C2=B1 91%  interrupts.CPU44.=
RES:Rescheduling_interrupts
>     172794 =C2=B1114%     -99.5%     838.33 =C2=B1  4%  interrupts.CPU45.=
CAL:Function_call_interrupts
>      89408 =C2=B1111%     -99.6%     326.00 =C2=B1 23%  interrupts.CPU45.=
RES:Rescheduling_interrupts
>      34858 =C2=B1 59%     -97.3%     947.00 =C2=B1 13%  interrupts.CPU46.=
CAL:Function_call_interrupts
>      22612 =C2=B1 53%     -87.6%       2794 =C2=B1 27%  interrupts.CPU46.=
RES:Rescheduling_interrupts
>      41349 =C2=B1 57%     -97.6%     996.67 =C2=B1 10%  interrupts.CPU47.=
CAL:Function_call_interrupts
>      27498 =C2=B1 54%     -93.7%       1725 =C2=B1 89%  interrupts.CPU47.=
RES:Rescheduling_interrupts
>      45388 =C2=B1 61%     -97.5%       1141 =C2=B1 57%  interrupts.CPU5.C=
AL:Function_call_interrupts
>      32500 =C2=B1 63%     -96.7%       1063 =C2=B1 95%  interrupts.CPU5.R=
ES:Rescheduling_interrupts
>     534772 =C2=B1105%     -99.8%     843.33 =C2=B1  3%  interrupts.CPU6.C=
AL:Function_call_interrupts
>     259978 =C2=B1 94%     -98.5%       4008 =C2=B1  4%  interrupts.CPU6.R=
ES:Rescheduling_interrupts
>     589336 =C2=B1 71%     -99.8%       1042 =C2=B1 25%  interrupts.CPU7.C=
AL:Function_call_interrupts
>     311886 =C2=B1 69%     -99.4%       1966 =C2=B1 66%  interrupts.CPU7.R=
ES:Rescheduling_interrupts
>     363153 =C2=B1 95%     -99.8%     858.00 =C2=B1  5%  interrupts.CPU8.C=
AL:Function_call_interrupts
>     190915 =C2=B1 83%     -98.1%       3681 =C2=B1 94%  interrupts.CPU8.R=
ES:Rescheduling_interrupts
>      78806 =C2=B1 46%     -98.9%     905.33 =C2=B1  7%  interrupts.CPU9.C=
AL:Function_call_interrupts
>      47384 =C2=B1 29%     -95.9%       1963 =C2=B1 58%  interrupts.CPU9.R=
ES:Rescheduling_interrupts
>    9209745 =C2=B1 15%     -99.0%      95188 =C2=B1  9%  interrupts.RES:Re=
scheduling_interrupts
>      20.15 =C2=B1  4%     -14.2        5.98 =C2=B1 15%  perf-profile.call=
trace.cycles-pp.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
>      15.92 =C2=B1  4%     -11.9        3.98 =C2=B1  7%  perf-profile.call=
trace.cycles-pp.signal_wake_up_state.__send_signal.do_send_sig_info.kill_pi=
d_info.do_rt_sigqueueinfo
>      15.71 =C2=B1  4%     -11.8        3.95 =C2=B1  7%  perf-profile.call=
trace.cycles-pp.try_to_wake_up.signal_wake_up_state.__send_signal.do_send_s=
ig_info.kill_pid_info
>      13.68 =C2=B1  6%     -10.8        2.93 =C2=B1 10%  perf-profile.call=
trace.cycles-pp.schedule_hrtimeout_range_clock.do_sigtimedwait.__x64_sys_rt=
_sigtimedwait.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      12.23 =C2=B1 26%     -10.4        1.80 =C2=B1 38%  perf-profile.call=
trace.cycles-pp.group_send_sig_info.kill_pid_info.do_rt_sigqueueinfo.__x64_=
sys_rt_sigqueueinfo.do_syscall_64
>      11.55 =C2=B1 27%     -10.0        1.56 =C2=B1 39%  perf-profile.call=
trace.cycles-pp.security_task_kill.group_send_sig_info.kill_pid_info.do_rt_=
sigqueueinfo.__x64_sys_rt_sigqueueinfo
>      11.33 =C2=B1 27%      -9.8        1.49 =C2=B1 40%  perf-profile.call=
trace.cycles-pp.apparmor_task_kill.security_task_kill.group_send_sig_info.k=
ill_pid_info.do_rt_sigqueueinfo
>      11.78 =C2=B1  5%      -9.3        2.52 =C2=B1  9%  perf-profile.call=
trace.cycles-pp.schedule.schedule_hrtimeout_range_clock.do_sigtimedwait.__x=
64_sys_rt_sigtimedwait.do_syscall_64
>      11.53 =C2=B1  5%      -9.1        2.47 =C2=B1  9%  perf-profile.call=
trace.cycles-pp.__sched_text_start.schedule.schedule_hrtimeout_range_clock.=
do_sigtimedwait.__x64_sys_rt_sigtimedwait
>       8.27 =C2=B1 13%      -6.3        1.99 =C2=B1  7%  perf-profile.call=
trace.cycles-pp.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_S=
YSCALL_64_after_hwframe
>       7.32 =C2=B1  2%      -4.9        2.43 =C2=B1 25%  perf-profile.call=
trace.cycles-pp.syscall_return_via_sysret
>       6.20 =C2=B1 13%      -4.7        1.53 =C2=B1 10%  perf-profile.call=
trace.cycles-pp.schedule.exit_to_user_mode_prepare.syscall_exit_to_user_mod=
e.entry_SYSCALL_64_after_hwframe
>       5.94 =C2=B1 13%      -4.5        1.46 =C2=B1 10%  perf-profile.call=
trace.cycles-pp.__sched_text_start.schedule.exit_to_user_mode_prepare.sysca=
ll_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
>       6.32 =C2=B1  8%      -4.3        2.07 =C2=B1  6%  perf-profile.call=
trace.cycles-pp.select_task_rq_fair.try_to_wake_up.signal_wake_up_state.__s=
end_signal.do_send_sig_info
>       4.57 =C2=B1 30%      -4.1        0.44 =C2=B1 74%  perf-profile.call=
trace.cycles-pp.aa_get_task_label.apparmor_task_kill.security_task_kill.gro=
up_send_sig_info.kill_pid_info
>       5.55 =C2=B1  8%      -3.7        1.90 =C2=B1  6%  perf-profile.call=
trace.cycles-pp.select_idle_sibling.select_task_rq_fair.try_to_wake_up.sign=
al_wake_up_state.__send_signal
>       4.43 =C2=B1  7%      -3.4        0.99 =C2=B1  6%  perf-profile.call=
trace.cycles-pp.ttwu_do_activate.try_to_wake_up.signal_wake_up_state.__send=
_signal.do_send_sig_info
>       4.29 =C2=B1  7%      -3.3        0.95 =C2=B1  6%  perf-profile.call=
trace.cycles-pp.enqueue_task_fair.ttwu_do_activate.try_to_wake_up.signal_wa=
ke_up_state.__send_signal
>       4.19 =C2=B1  6%      -3.3        0.92 =C2=B1  8%  perf-profile.call=
trace.cycles-pp.dequeue_task_fair.__sched_text_start.schedule.schedule_hrti=
meout_range_clock.do_sigtimedwait
>       4.60            -2.9        1.69 =C2=B1 28%  perf-profile.calltrace=
.cycles-pp.__entry_text_start
>       1.93 =C2=B1 16%      -1.6        0.37 =C2=B1 70%  perf-profile.call=
trace.cycles-pp.pick_next_task_fair.__sched_text_start.schedule.exit_to_use=
r_mode_prepare.syscall_exit_to_user_mode
>       2.40 =C2=B1  6%      -1.5        0.86 =C2=B1  6%  perf-profile.call=
trace.cycles-pp.available_idle_cpu.select_idle_sibling.select_task_rq_fair.=
try_to_wake_up.signal_wake_up_state
>       0.00            +0.7        0.67        perf-profile.calltrace.cycl=
es-pp.inc_rlimit_ucounts_and_test.__sigqueue_alloc.__send_signal.do_send_si=
g_info.kill_pid_info
>       0.67 =C2=B1 16%      +2.4        3.11 =C2=B1 53%  perf-profile.call=
trace.cycles-pp.__lock_task_sighand.do_send_sig_info.kill_pid_info.do_rt_si=
gqueueinfo.__x64_sys_rt_sigqueueinfo
>       0.42 =C2=B1 71%      +2.7        3.08 =C2=B1 53%  perf-profile.call=
trace.cycles-pp._raw_spin_lock_irqsave.__lock_task_sighand.do_send_sig_info=
.kill_pid_info.do_rt_sigqueueinfo
>       0.00            +3.0        2.98 =C2=B1 54%  perf-profile.calltrace=
.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__lock_t=
ask_sighand.do_send_sig_info.kill_pid_info
>       0.00            +3.2        3.23 =C2=B1 51%  perf-profile.calltrace=
.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.do_sigtimedw=
ait.__x64_sys_rt_sigtimedwait.do_syscall_64
>       0.00            +3.3        3.29 =C2=B1 51%  perf-profile.calltrace=
.cycles-pp._raw_spin_lock_irq.do_sigtimedwait.__x64_sys_rt_sigtimedwait.do_=
syscall_64.entry_SYSCALL_64_after_hwframe
>      35.47 =C2=B1  7%      +9.5       45.02        perf-profile.calltrace=
.cycles-pp.__x64_sys_rt_sigqueueinfo.do_syscall_64.entry_SYSCALL_64_after_h=
wframe
>      34.17 =C2=B1  7%     +10.4       44.54        perf-profile.calltrace=
.cycles-pp.do_rt_sigqueueinfo.__x64_sys_rt_sigqueueinfo.do_syscall_64.entry=
_SYSCALL_64_after_hwframe
>      33.33 =C2=B1  7%     +10.9       44.22        perf-profile.calltrace=
.cycles-pp.kill_pid_info.do_rt_sigqueueinfo.__x64_sys_rt_sigqueueinfo.do_sy=
scall_64.entry_SYSCALL_64_after_hwframe
>      81.67           +12.6       94.25        perf-profile.calltrace.cycl=
es-pp.entry_SYSCALL_64_after_hwframe
>      19.16 =C2=B1  4%     +19.5       38.64 =C2=B1  8%  perf-profile.call=
trace.cycles-pp.__send_signal.do_send_sig_info.kill_pid_info.do_rt_sigqueue=
info.__x64_sys_rt_sigqueueinfo
>      21.31 =C2=B1  6%     +20.5       41.77 =C2=B1  4%  perf-profile.call=
trace.cycles-pp.__x64_sys_rt_sigtimedwait.do_syscall_64.entry_SYSCALL_64_af=
ter_hwframe
>      20.83 =C2=B1  3%     +21.5       42.33 =C2=B1  3%  perf-profile.call=
trace.cycles-pp.do_send_sig_info.kill_pid_info.do_rt_sigqueueinfo.__x64_sys=
_rt_sigqueueinfo.do_syscall_64
>      19.46 =C2=B1  5%     +21.9       41.31 =C2=B1  4%  perf-profile.call=
trace.cycles-pp.do_sigtimedwait.__x64_sys_rt_sigtimedwait.do_syscall_64.ent=
ry_SYSCALL_64_after_hwframe
>      59.72 =C2=B1  2%     +28.1       87.78 =C2=B1  2%  perf-profile.call=
trace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       3.78 =C2=B1  8%     +30.8       34.58 =C2=B1  9%  perf-profile.call=
trace.cycles-pp.dequeue_signal.do_sigtimedwait.__x64_sys_rt_sigtimedwait.do=
_syscall_64.entry_SYSCALL_64_after_hwframe
>       3.07 =C2=B1  8%     +31.3       34.40 =C2=B1  9%  perf-profile.call=
trace.cycles-pp.__dequeue_signal.dequeue_signal.do_sigtimedwait.__x64_sys_r=
t_sigtimedwait.do_syscall_64
>       1.74 =C2=B1  9%     +32.1       33.86 =C2=B1  9%  perf-profile.call=
trace.cycles-pp.__sigqueue_free.__dequeue_signal.dequeue_signal.do_sigtimed=
wait.__x64_sys_rt_sigtimedwait
>       1.94 =C2=B1  8%     +32.5       34.40 =C2=B1  8%  perf-profile.call=
trace.cycles-pp.__sigqueue_alloc.__send_signal.do_send_sig_info.kill_pid_in=
fo.do_rt_sigqueueinfo
>       0.00           +32.8       32.81 =C2=B1  9%  perf-profile.calltrace=
.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.put_ucou=
nts.__sigqueue_free.__dequeue_signal
>       0.00           +33.0       33.02 =C2=B1  8%  perf-profile.calltrace=
.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_ucou=
nts.__sigqueue_alloc.__send_signal
>       0.00           +33.2       33.22 =C2=B1  9%  perf-profile.calltrace=
.cycles-pp._raw_spin_lock_irqsave.put_ucounts.__sigqueue_free.__dequeue_sig=
nal.dequeue_signal
>       0.00           +33.3       33.32 =C2=B1  9%  perf-profile.calltrace=
.cycles-pp.put_ucounts.__sigqueue_free.__dequeue_signal.dequeue_signal.do_s=
igtimedwait
>       0.00           +33.5       33.48 =C2=B1  8%  perf-profile.calltrace=
.cycles-pp._raw_spin_lock_irqsave.get_ucounts.__sigqueue_alloc.__send_signa=
l.do_send_sig_info
>       0.00           +33.6       33.57 =C2=B1  8%  perf-profile.calltrace=
.cycles-pp.get_ucounts.__sigqueue_alloc.__send_signal.do_send_sig_info.kill=
_pid_info
>      20.22 =C2=B1  4%     -14.2        6.00 =C2=B1 15%  perf-profile.chil=
dren.cycles-pp.syscall_exit_to_user_mode
>      18.14 =C2=B1  8%     -14.1        4.06 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.schedule
>      17.92 =C2=B1  7%     -14.0        3.96 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.__sched_text_start
>      15.92 =C2=B1  4%     -11.9        3.98 =C2=B1  7%  perf-profile.chil=
dren.cycles-pp.signal_wake_up_state
>      15.73 =C2=B1  4%     -11.8        3.96 =C2=B1  7%  perf-profile.chil=
dren.cycles-pp.try_to_wake_up
>      13.71 =C2=B1  6%     -10.8        2.93 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.schedule_hrtimeout_range_clock
>      12.24 =C2=B1 26%     -10.4        1.80 =C2=B1 38%  perf-profile.chil=
dren.cycles-pp.group_send_sig_info
>      11.56 =C2=B1 27%     -10.0        1.56 =C2=B1 39%  perf-profile.chil=
dren.cycles-pp.security_task_kill
>      11.35 =C2=B1 27%      -9.9        1.49 =C2=B1 40%  perf-profile.chil=
dren.cycles-pp.apparmor_task_kill
>       8.45 =C2=B1 12%      -6.5        2.00 =C2=B1  7%  perf-profile.chil=
dren.cycles-pp.exit_to_user_mode_prepare
>       8.04            -5.3        2.71 =C2=B1 25%  perf-profile.children.=
cycles-pp.syscall_return_via_sysret
>       6.34 =C2=B1  8%      -4.3        2.07 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.select_task_rq_fair
>       4.58 =C2=B1 30%      -4.0        0.55 =C2=B1 36%  perf-profile.chil=
dren.cycles-pp.aa_get_task_label
>       6.03            -4.0        2.05 =C2=B1 28%  perf-profile.children.=
cycles-pp.__entry_text_start
>       4.70 =C2=B1  6%      -3.7        0.99 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.ttwu_do_activate
>       5.63 =C2=B1  8%      -3.7        1.93 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.select_idle_sibling
>       4.57 =C2=B1  6%      -3.6        0.96 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.enqueue_task_fair
>       4.23 =C2=B1  7%      -3.3        0.93 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.dequeue_task_fair
>       3.78 =C2=B1 12%      -2.9        0.91 =C2=B1 11%  perf-profile.chil=
dren.cycles-pp.pick_next_task_fair
>       3.44 =C2=B1  9%      -2.7        0.78 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.switch_mm_irqs_off
>       3.07 =C2=B1 10%      -2.4        0.68 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.update_load_avg
>       2.96 =C2=B1  3%      -2.3        0.69 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.update_curr
>       2.35 =C2=B1  3%      -1.9        0.48 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.enqueue_entity
>       2.26 =C2=B1 13%      -1.7        0.56 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.load_new_mm_cr3
>       2.44 =C2=B1  6%      -1.6        0.86 =C2=B1  5%  perf-profile.chil=
dren.cycles-pp.available_idle_cpu
>       1.82 =C2=B1  4%      -1.4        0.41 =C2=B1  7%  perf-profile.chil=
dren.cycles-pp.dequeue_entity
>       1.93 =C2=B1  3%      -1.4        0.52 =C2=B1 32%  perf-profile.chil=
dren.cycles-pp.entry_SYSCALL_64_safe_stack
>       1.63 =C2=B1 10%      -1.3        0.28 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp._raw_spin_lock
>       1.59 =C2=B1 13%      -1.3        0.30 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.switch_fpu_return
>       1.63 =C2=B1 11%      -1.2        0.39 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.reweight_entity
>       1.47 =C2=B1  7%      -1.2        0.31 =C2=B1 11%  perf-profile.chil=
dren.cycles-pp.__switch_to
>       1.25 =C2=B1 12%      -1.0        0.27 =C2=B1 13%  perf-profile.chil=
dren.cycles-pp.__switch_to_asm
>       1.21 =C2=B1 10%      -0.9        0.27 =C2=B1 13%  perf-profile.chil=
dren.cycles-pp.set_next_entity
>       1.07 =C2=B1  7%      -0.9        0.13 =C2=B1 25%  perf-profile.chil=
dren.cycles-pp.finish_task_switch
>       1.30 =C2=B1  4%      -0.9        0.41 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp._copy_from_user
>       1.11 =C2=B1  7%      -0.8        0.27 =C2=B1 12%  perf-profile.chil=
dren.cycles-pp.update_rq_clock
>       1.04 =C2=B1  4%      -0.8        0.24 =C2=B1 15%  perf-profile.chil=
dren.cycles-pp.ttwu_do_wakeup
>       0.99 =C2=B1 13%      -0.8        0.21 =C2=B1 14%  perf-profile.chil=
dren.cycles-pp.hrtimer_start_range_ns
>       0.98 =C2=B1  4%      -0.8        0.22 =C2=B1 13%  perf-profile.chil=
dren.cycles-pp.check_preempt_curr
>       1.03            -0.8        0.28 =C2=B1  4%  perf-profile.children.=
cycles-pp.recalc_sigpending
>       0.97 =C2=B1 12%      -0.7        0.22 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.__update_load_avg_se
>       0.90 =C2=B1  8%      -0.7        0.18 =C2=B1 12%  perf-profile.chil=
dren.cycles-pp.perf_trace_sched_wakeup_template
>       0.95 =C2=B1 10%      -0.7        0.23 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.__update_load_avg_cfs_rq
>       0.94 =C2=B1 33%      -0.7        0.23 =C2=B1 40%  perf-profile.chil=
dren.cycles-pp.aa_may_signal
>       0.94 =C2=B1  6%      -0.7        0.23 =C2=B1  2%  perf-profile.chil=
dren.cycles-pp.copy_siginfo_to_user
>       0.95 =C2=B1  6%      -0.7        0.27 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.__might_fault
>       0.85 =C2=B1  5%      -0.7        0.19 =C2=B1 11%  perf-profile.chil=
dren.cycles-pp.check_preempt_wakeup
>       0.83 =C2=B1  9%      -0.6        0.19 =C2=B1  7%  perf-profile.chil=
dren.cycles-pp.___perf_sw_event
>       1.00 =C2=B1  2%      -0.6        0.36 =C2=B1 20%  perf-profile.chil=
dren.cycles-pp.__copy_siginfo_from_user
>       0.79 =C2=B1 17%      -0.6        0.19 =C2=B1 11%  perf-profile.chil=
dren.cycles-pp.put_prev_entity
>       0.80 =C2=B1 12%      -0.6        0.20 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.pick_next_entity
>       0.82 =C2=B1  2%      -0.5        0.29 =C2=B1 24%  perf-profile.chil=
dren.cycles-pp.__x64_sys_getpid
>       0.68 =C2=B1  2%      -0.5        0.16 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp.update_cfs_group
>       0.87 =C2=B1 17%      -0.5        0.38        perf-profile.children.=
cycles-pp.asm_call_sysvec_on_stack
>       0.53 =C2=B1  6%      -0.5        0.06 =C2=B1 16%  perf-profile.chil=
dren.cycles-pp.complete_signal
>       0.58 =C2=B1  6%      -0.5        0.12 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.sched_clock_cpu
>       0.55 =C2=B1  5%      -0.4        0.10 =C2=B1 12%  perf-profile.chil=
dren.cycles-pp.hrtimer_try_to_cancel
>       0.79 =C2=B1 12%      -0.4        0.35 =C2=B1  7%  perf-profile.chil=
dren.cycles-pp.cpumask_next_wrap
>       0.62 =C2=B1 18%      -0.4        0.19 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp._find_next_bit
>       0.71 =C2=B1  2%      -0.4        0.28 =C2=B1 34%  perf-profile.chil=
dren.cycles-pp.__task_pid_nr_ns
>       0.62 =C2=B1  3%      -0.4        0.21 =C2=B1 30%  perf-profile.chil=
dren.cycles-pp.__x64_sys_getuid
>       0.53 =C2=B1 14%      -0.4        0.14 =C2=B1 17%  perf-profile.chil=
dren.cycles-pp.__calc_delta
>       0.59 =C2=B1  8%      -0.4        0.20 =C2=B1 32%  perf-profile.chil=
dren.cycles-pp.check_kill_permission
>       0.50 =C2=B1  6%      -0.4        0.11 =C2=B1 11%  perf-profile.chil=
dren.cycles-pp.sched_clock
>       0.50 =C2=B1 13%      -0.4        0.12 =C2=B1 10%  perf-profile.chil=
dren.cycles-pp.copy_fpregs_to_fpstate
>       0.47 =C2=B1  6%      -0.4        0.09 =C2=B1 18%  perf-profile.chil=
dren.cycles-pp.perf_tp_event
>       0.48 =C2=B1  6%      -0.4        0.10 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.native_sched_clock
>       0.48 =C2=B1  3%      -0.4        0.11 =C2=B1  4%  perf-profile.chil=
dren.cycles-pp.___might_sleep
>       0.74 =C2=B1 12%      -0.4        0.39        perf-profile.children.=
cycles-pp.kmem_cache_free
>       0.45 =C2=B1  8%      -0.3        0.13 =C2=B1 13%  perf-profile.chil=
dren.cycles-pp._copy_to_user
>       0.36 =C2=B1  5%      -0.3        0.06 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.__set_task_blocked
>       0.35 =C2=B1 22%      -0.3        0.07 =C2=B1 11%  perf-profile.chil=
dren.cycles-pp.cpumask_next
>       0.38 =C2=B1  7%      -0.3        0.10 =C2=B1 14%  perf-profile.chil=
dren.cycles-pp.ktime_get
>       0.46 =C2=B1 10%      -0.3        0.19 =C2=B1 36%  perf-profile.chil=
dren.cycles-pp.__radix_tree_lookup
>       0.64 =C2=B1  4%      -0.3        0.37 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp._raw_spin_unlock_irqrestore
>       0.33 =C2=B1 16%      -0.3        0.06 =C2=B1 14%  perf-profile.chil=
dren.cycles-pp.cpuacct_charge
>       0.53            -0.3        0.26 =C2=B1 33%  perf-profile.children.=
cycles-pp.send_signal
>       0.33 =C2=B1 16%      -0.3        0.07 =C2=B1 12%  perf-profile.chil=
dren.cycles-pp.__wrgsbase_inactive
>       0.34 =C2=B1  8%      -0.2        0.09 =C2=B1  5%  perf-profile.chil=
dren.cycles-pp.update_min_vruntime
>       0.39 =C2=B1  3%      -0.2        0.15 =C2=B1 12%  perf-profile.chil=
dren.cycles-pp.copy_user_generic_unrolled
>       0.32 =C2=B1  6%      -0.2        0.07 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp.perf_trace_sched_stat_runtime
>       0.28 =C2=B1  2%      -0.2        0.04 =C2=B1 71%  perf-profile.chil=
dren.cycles-pp.lock_hrtimer_base
>       0.30 =C2=B1  9%      -0.2        0.06 =C2=B1  7%  perf-profile.chil=
dren.cycles-pp.set_next_buddy
>       0.35 =C2=B1  5%      -0.2        0.11 =C2=B1 36%  perf-profile.chil=
dren.cycles-pp.syscall_enter_from_user_mode
>       0.30 =C2=B1  5%      -0.2        0.07 =C2=B1 17%  perf-profile.chil=
dren.cycles-pp.rb_erase
>       0.32 =C2=B1  2%      -0.2        0.10 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.__x86_retpoline_rax
>       0.30 =C2=B1  5%      -0.2        0.08 =C2=B1 14%  perf-profile.chil=
dren.cycles-pp.__might_sleep
>       0.29 =C2=B1  7%      -0.2        0.07 =C2=B1 12%  perf-profile.chil=
dren.cycles-pp.__clear_user
>       0.31 =C2=B1 14%      -0.2        0.09 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.clear_buddies
>       0.25 =C2=B1  3%      -0.2        0.05        perf-profile.children.=
cycles-pp.recalc_sigpending_tsk
>       0.29 =C2=B1 12%      -0.2        0.09 =C2=B1 22%  perf-profile.chil=
dren.cycles-pp.prepare_signal
>       0.30 =C2=B1  4%      -0.2        0.11 =C2=B1 34%  perf-profile.chil=
dren.cycles-pp.from_kuid_munged
>       0.27 =C2=B1  4%      -0.2        0.09 =C2=B1 36%  perf-profile.chil=
dren.cycles-pp.map_id_up
>       0.21 =C2=B1 21%      -0.2        0.03 =C2=B1 70%  perf-profile.chil=
dren.cycles-pp.enqueue_hrtimer
>       0.22 =C2=B1 13%      -0.2        0.06 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.get_timespec64
>       0.22 =C2=B1 17%      -0.2        0.06 =C2=B1 86%  perf-profile.chil=
dren.cycles-pp.__cgroup_account_cputime
>       0.20 =C2=B1  4%      -0.2        0.04 =C2=B1 76%  perf-profile.chil=
dren.cycles-pp.syscall_exit_to_user_mode_prepare
>       0.20 =C2=B1  6%      -0.2        0.05        perf-profile.children.=
cycles-pp.__list_del_entry_valid
>       0.19 =C2=B1  7%      -0.2        0.04 =C2=B1 71%  perf-profile.chil=
dren.cycles-pp.perf_trace_sched_switch
>       0.23 =C2=B1  8%      -0.1        0.08 =C2=B1 31%  perf-profile.chil=
dren.cycles-pp.audit_signal_info
>       0.22 =C2=B1  5%      -0.1        0.08 =C2=B1 16%  perf-profile.chil=
dren.cycles-pp.rcu_read_unlock_strict
>       0.17 =C2=B1  9%      -0.1        0.03 =C2=B1 70%  perf-profile.chil=
dren.cycles-pp.read_tsc
>       0.18 =C2=B1  7%      -0.1        0.05 =C2=B1 72%  perf-profile.chil=
dren.cycles-pp.audit_signal_info_syscall
>       0.17 =C2=B1  5%      -0.1        0.11 =C2=B1  4%  perf-profile.chil=
dren.cycles-pp.kmem_cache_alloc
>       0.00            +0.5        0.51 =C2=B1  3%  perf-profile.children.=
cycles-pp.dec_rlimit_ucounts
>       0.00            +0.7        0.67 =C2=B1  2%  perf-profile.children.=
cycles-pp.inc_rlimit_ucounts_and_test
>       0.68 =C2=B1 16%      +2.4        3.11 =C2=B1 53%  perf-profile.chil=
dren.cycles-pp.__lock_task_sighand
>       0.42 =C2=B1  6%      +2.9        3.30 =C2=B1 51%  perf-profile.chil=
dren.cycles-pp._raw_spin_lock_irq
>      35.50 =C2=B1  7%      +9.5       45.03        perf-profile.children.=
cycles-pp.__x64_sys_rt_sigqueueinfo
>      34.19 =C2=B1  7%     +10.4       44.55        perf-profile.children.=
cycles-pp.do_rt_sigqueueinfo
>      33.35 =C2=B1  7%     +10.9       44.22        perf-profile.children.=
cycles-pp.kill_pid_info
>      81.79           +12.5       94.33        perf-profile.children.cycle=
s-pp.entry_SYSCALL_64_after_hwframe
>      19.21 =C2=B1  4%     +19.4       38.65 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.__send_signal
>      21.36 =C2=B1  6%     +20.4       41.78 =C2=B1  4%  perf-profile.chil=
dren.cycles-pp.__x64_sys_rt_sigtimedwait
>      20.86 =C2=B1  3%     +21.5       42.34 =C2=B1  3%  perf-profile.chil=
dren.cycles-pp.do_send_sig_info
>      19.50 =C2=B1  5%     +21.8       41.33 =C2=B1  4%  perf-profile.chil=
dren.cycles-pp.do_sigtimedwait
>      59.88 =C2=B1  2%     +28.0       87.85 =C2=B1  2%  perf-profile.chil=
dren.cycles-pp.do_syscall_64
>       3.81 =C2=B1  8%     +30.9       34.66 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.dequeue_signal
>       3.09 =C2=B1  8%     +31.3       34.41 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.__dequeue_signal
>       1.74 =C2=B1  9%     +32.1       33.87 =C2=B1  9%  perf-profile.chil=
dren.cycles-pp.__sigqueue_free
>       1.95 =C2=B1  8%     +32.5       34.40 =C2=B1  8%  perf-profile.chil=
dren.cycles-pp.__sigqueue_alloc
>       0.00           +33.3       33.32 =C2=B1  9%  perf-profile.children.=
cycles-pp.put_ucounts
>       0.00           +33.6       33.58 =C2=B1  8%  perf-profile.children.=
cycles-pp.get_ucounts
>       1.07 =C2=B1 11%     +68.8       69.87 =C2=B1  6%  perf-profile.chil=
dren.cycles-pp._raw_spin_lock_irqsave
>       0.74 =C2=B1 39%     +71.3       72.04 =C2=B1  4%  perf-profile.chil=
dren.cycles-pp.native_queued_spin_lock_slowpath
>      11.75 =C2=B1  2%      -7.8        3.95 =C2=B1 26%  perf-profile.self=
.cycles-pp.syscall_exit_to_user_mode
>       8.02            -5.3        2.70 =C2=B1 25%  perf-profile.self.cycl=
es-pp.syscall_return_via_sysret
>       5.78 =C2=B1 25%      -5.1        0.71 =C2=B1 43%  perf-profile.self=
.cycles-pp.apparmor_task_kill
>       4.55 =C2=B1 30%      -4.0        0.53 =C2=B1 34%  perf-profile.self=
.cycles-pp.aa_get_task_label
>       6.02            -4.0        2.05 =C2=B1 28%  perf-profile.self.cycl=
es-pp.__entry_text_start
>       1.79 =C2=B1  9%      -1.7        0.06 =C2=B1 13%  perf-profile.self=
.cycles-pp.__sigqueue_alloc
>       2.22 =C2=B1  9%      -1.7        0.50 =C2=B1  9%  perf-profile.self=
.cycles-pp.__sched_text_start
>       2.25 =C2=B1 13%      -1.7        0.55 =C2=B1 11%  perf-profile.self=
.cycles-pp.load_new_mm_cr3
>       2.40 =C2=B1  6%      -1.5        0.85 =C2=B1  6%  perf-profile.self=
.cycles-pp.available_idle_cpu
>       1.57 =C2=B1 12%      -1.3        0.30 =C2=B1 10%  perf-profile.self=
.cycles-pp.switch_fpu_return
>       1.74 =C2=B1  6%      -1.2        0.50 =C2=B1 11%  perf-profile.self=
.cycles-pp.entry_SYSCALL_64_after_hwframe
>       1.79 =C2=B1  8%      -1.2        0.60 =C2=B1  6%  perf-profile.self=
.cycles-pp.select_idle_sibling
>       1.41 =C2=B1  7%      -1.1        0.30 =C2=B1 11%  perf-profile.self=
.cycles-pp.__switch_to
>       1.25 =C2=B1  3%      -1.0        0.27 =C2=B1  8%  perf-profile.self=
.cycles-pp.update_curr
>       1.23 =C2=B1 12%      -1.0        0.27 =C2=B1 13%  perf-profile.self=
.cycles-pp.__switch_to_asm
>       1.17 =C2=B1  7%      -0.9        0.23 =C2=B1  9%  perf-profile.self=
.cycles-pp.update_load_avg
>       1.15 =C2=B1  2%      -0.9        0.21 =C2=B1  5%  perf-profile.self=
.cycles-pp.switch_mm_irqs_off
>       1.13 =C2=B1  3%      -0.8        0.28 =C2=B1  8%  perf-profile.self=
.cycles-pp._raw_spin_lock
>       0.94 =C2=B1 13%      -0.8        0.14 =C2=B1  9%  perf-profile.self=
.cycles-pp.try_to_wake_up
>       1.06            -0.7        0.32 =C2=B1 28%  perf-profile.self.cycl=
es-pp.do_syscall_64
>       0.93 =C2=B1 12%      -0.7        0.22 =C2=B1 12%  perf-profile.self=
.cycles-pp.__update_load_avg_se
>       0.93 =C2=B1 33%      -0.7        0.23 =C2=B1 40%  perf-profile.self=
.cycles-pp.aa_may_signal
>       0.90 =C2=B1 10%      -0.7        0.22 =C2=B1  9%  perf-profile.self=
.cycles-pp.__update_load_avg_cfs_rq
>       0.77            -0.6        0.15 =C2=B1  5%  perf-profile.self.cycl=
es-pp.recalc_sigpending
>       0.77 =C2=B1 13%      -0.6        0.20 =C2=B1  7%  perf-profile.self=
.cycles-pp.reweight_entity
>       0.74 =C2=B1  7%      -0.6        0.19 =C2=B1 11%  perf-profile.self=
.cycles-pp.update_rq_clock
>       0.67 =C2=B1  7%      -0.5        0.14 =C2=B1  6%  perf-profile.self=
.cycles-pp.___perf_sw_event
>       0.63 =C2=B1  7%      -0.5        0.11 =C2=B1 11%  perf-profile.self=
.cycles-pp.enqueue_entity
>       0.67 =C2=B1  3%      -0.5        0.15 =C2=B1  3%  perf-profile.self=
.cycles-pp.update_cfs_group
>       0.66 =C2=B1  9%      -0.5        0.16 =C2=B1 12%  perf-profile.self=
.cycles-pp.pick_next_task_fair
>       0.61 =C2=B1 13%      -0.5        0.12 =C2=B1  4%  perf-profile.self=
.cycles-pp.enqueue_task_fair
>       0.60 =C2=B1  5%      -0.5        0.11 =C2=B1 14%  perf-profile.self=
.cycles-pp.dequeue_task_fair
>       0.62 =C2=B1  8%      -0.5        0.14 =C2=B1  5%  perf-profile.self=
.cycles-pp.select_task_rq_fair
>       0.63 =C2=B1  6%      -0.5        0.16 =C2=B1 10%  perf-profile.self=
.cycles-pp.do_sigtimedwait
>       0.61 =C2=B1 18%      -0.4        0.19 =C2=B1 10%  perf-profile.self=
.cycles-pp._find_next_bit
>       0.68 =C2=B1  3%      -0.4        0.27 =C2=B1 33%  perf-profile.self=
.cycles-pp.__task_pid_nr_ns
>       0.54 =C2=B1  3%      -0.4        0.14 =C2=B1  6%  perf-profile.self=
.cycles-pp.__dequeue_signal
>       0.51            -0.4        0.12 =C2=B1 20%  perf-profile.self.cycl=
es-pp.__send_signal
>       0.53 =C2=B1 14%      -0.4        0.14 =C2=B1 15%  perf-profile.self=
.cycles-pp.__calc_delta
>       0.49 =C2=B1 13%      -0.4        0.12 =C2=B1 10%  perf-profile.self=
.cycles-pp.copy_fpregs_to_fpstate
>       0.46 =C2=B1  7%      -0.4        0.09 =C2=B1 10%  perf-profile.self=
.cycles-pp.native_sched_clock
>       0.46 =C2=B1  3%      -0.4        0.10 =C2=B1  4%  perf-profile.self=
.cycles-pp.___might_sleep
>       0.50 =C2=B1  7%      -0.3        0.16 =C2=B1 23%  perf-profile.self=
.cycles-pp.exit_to_user_mode_prepare
>       0.50 =C2=B1  3%      -0.3        0.17 =C2=B1 29%  perf-profile.self=
.cycles-pp.entry_SYSCALL_64_safe_stack
>       0.44 =C2=B1 14%      -0.3        0.10 =C2=B1 16%  perf-profile.self=
.cycles-pp.schedule
>       0.42 =C2=B1  5%      -0.3        0.09 =C2=B1  9%  perf-profile.self=
.cycles-pp.finish_task_switch
>       0.43 =C2=B1 11%      -0.3        0.10 =C2=B1  9%  perf-profile.self=
.cycles-pp.pick_next_entity
>       0.41 =C2=B1 10%      -0.3        0.08 =C2=B1  5%  perf-profile.self=
.cycles-pp.__x64_sys_rt_sigtimedwait
>       0.44 =C2=B1  6%      -0.3        0.13 =C2=B1  6%  perf-profile.self=
.cycles-pp._copy_from_user
>       0.50 =C2=B1  3%      -0.3        0.20 =C2=B1 11%  perf-profile.self=
.cycles-pp._raw_spin_unlock_irqrestore
>       0.63 =C2=B1 20%      -0.3        0.35 =C2=B1  6%  perf-profile.self=
.cycles-pp.kmem_cache_free
>       0.37 =C2=B1  3%      -0.3        0.10 =C2=B1 12%  perf-profile.self=
.cycles-pp.check_preempt_wakeup
>       0.37 =C2=B1  7%      -0.3        0.10 =C2=B1  4%  perf-profile.self=
.cycles-pp.dequeue_entity
>       0.33 =C2=B1 15%      -0.3        0.06 =C2=B1 13%  perf-profile.self=
.cycles-pp.cpuacct_charge
>       0.46 =C2=B1 11%      -0.3        0.19 =C2=B1 36%  perf-profile.self=
.cycles-pp.__radix_tree_lookup
>       0.34 =C2=B1  3%      -0.3        0.07 =C2=B1 11%  perf-profile.self=
.cycles-pp._raw_spin_lock_irq
>       0.29 =C2=B1  7%      -0.3        0.04 =C2=B1 71%  perf-profile.self=
.cycles-pp.perf_tp_event
>       0.36 =C2=B1 11%      -0.3        0.10 =C2=B1  4%  perf-profile.self=
.cycles-pp.__might_fault
>       0.32 =C2=B1  7%      -0.2        0.08 =C2=B1  5%  perf-profile.self=
.cycles-pp.update_min_vruntime
>       0.31 =C2=B1 17%      -0.2        0.07 =C2=B1 12%  perf-profile.self=
.cycles-pp.__wrgsbase_inactive
>       0.37 =C2=B1  2%      -0.2        0.14 =C2=B1 13%  perf-profile.self=
.cycles-pp.copy_user_generic_unrolled
>       0.30 =C2=B1  4%      -0.2        0.07 =C2=B1  7%  perf-profile.self=
.cycles-pp.perf_trace_sched_stat_runtime
>       0.26 =C2=B1  8%      -0.2        0.04 =C2=B1 71%  perf-profile.self=
.cycles-pp.set_next_buddy
>       0.29 =C2=B1  5%      -0.2        0.07 =C2=B1 17%  perf-profile.self=
.cycles-pp.rb_erase
>       0.28 =C2=B1 11%      -0.2        0.06 =C2=B1 14%  perf-profile.self=
.cycles-pp.set_next_entity
>       0.30 =C2=B1  4%      -0.2        0.09 =C2=B1 30%  perf-profile.self=
.cycles-pp.__x64_sys_getuid
>       0.39 =C2=B1 13%      -0.2        0.18 =C2=B1  9%  perf-profile.self=
.cycles-pp.cpumask_next_wrap
>       0.27 =C2=B1  5%      -0.2        0.07 =C2=B1 17%  perf-profile.self=
.cycles-pp.__might_sleep
>       0.31 =C2=B1  3%      -0.2        0.12 =C2=B1 28%  perf-profile.self=
.cycles-pp.__x64_sys_rt_sigqueueinfo
>       0.24            -0.2        0.05        perf-profile.self.cycles-pp=
.recalc_sigpending_tsk
>       0.28 =C2=B1  5%      -0.2        0.09 =C2=B1 36%  perf-profile.self=
.cycles-pp.syscall_enter_from_user_mode
>       0.27 =C2=B1 12%      -0.2        0.08 =C2=B1 24%  perf-profile.self=
.cycles-pp.prepare_signal
>       0.27 =C2=B1 13%      -0.2        0.08 =C2=B1 10%  perf-profile.self=
.cycles-pp.clear_buddies
>       0.26 =C2=B1  3%      -0.2        0.08 =C2=B1 12%  perf-profile.self=
.cycles-pp.__x86_retpoline_rax
>       0.21 =C2=B1 17%      -0.2        0.04 =C2=B1 71%  perf-profile.self=
.cycles-pp.put_prev_entity
>       0.26 =C2=B1  4%      -0.2        0.09 =C2=B1 36%  perf-profile.self=
.cycles-pp.map_id_up
>       0.23 =C2=B1 13%      -0.2        0.07 =C2=B1 11%  perf-profile.self=
.cycles-pp.schedule_hrtimeout_range_clock
>       0.19 =C2=B1  8%      -0.2        0.04 =C2=B1 70%  perf-profile.self=
.cycles-pp.ktime_get
>       0.19 =C2=B1  9%      -0.1        0.04 =C2=B1 71%  perf-profile.self=
.cycles-pp.perf_trace_sched_switch
>       0.18 =C2=B1  4%      -0.1        0.03 =C2=B1 70%  perf-profile.self=
.cycles-pp.__list_del_entry_valid
>       0.19 =C2=B1  8%      -0.1        0.05 =C2=B1 78%  perf-profile.self=
.cycles-pp.check_kill_permission
>       0.26            -0.1        0.13 =C2=B1 26%  perf-profile.self.cycl=
es-pp.send_signal
>       0.21 =C2=B1  4%      -0.1        0.08 =C2=B1 26%  perf-profile.self=
.cycles-pp.__x64_sys_getpid
>       0.20 =C2=B1  2%      -0.1        0.06 =C2=B1 19%  perf-profile.self=
.cycles-pp.security_task_kill
>       0.17 =C2=B1  4%      -0.1        0.05 =C2=B1 78%  perf-profile.self=
.cycles-pp.kill_pid_info
>       0.16 =C2=B1  8%      -0.1        0.04 =C2=B1 71%  perf-profile.self=
.cycles-pp.rcu_read_unlock_strict
>       0.16 =C2=B1 10%      -0.1        0.05 =C2=B1 72%  perf-profile.self=
.cycles-pp.audit_signal_info_syscall
>       0.24 =C2=B1  8%      -0.1        0.14 =C2=B1  3%  perf-profile.self=
.cycles-pp.dequeue_signal
>       0.12 =C2=B1  4%      -0.1        0.04 =C2=B1 71%  perf-profile.self=
.cycles-pp.do_rt_sigqueueinfo
>       0.12 =C2=B1 11%      -0.1        0.04 =C2=B1 70%  perf-profile.self=
.cycles-pp.do_send_sig_info
>       0.15 =C2=B1  6%      -0.0        0.10        perf-profile.self.cycl=
es-pp.kmem_cache_alloc
>       0.00            +0.1        0.07 =C2=B1 11%  perf-profile.self.cycl=
es-pp.get_ucounts
>       0.00            +0.1        0.07 =C2=B1  6%  perf-profile.self.cycl=
es-pp.put_ucounts
>       0.88 =C2=B1  7%      +0.2        1.04        perf-profile.self.cycl=
es-pp._raw_spin_lock_irqsave
>       0.00            +0.5        0.51 =C2=B1  3%  perf-profile.self.cycl=
es-pp.dec_rlimit_ucounts
>       0.00            +0.7        0.67        perf-profile.self.cycles-pp=
.inc_rlimit_ucounts_and_test
>       0.74 =C2=B1 39%     +71.3       72.04 =C2=B1  4%  perf-profile.self=
.cycles-pp.native_queued_spin_lock_slowpath
>
>
>
>
>
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are prov=
ided
> for informational purposes only. Any difference in system hardware or sof=
tware
> design or configuration may affect actual performance.
>
>
> Thanks,
> Oliver Sang

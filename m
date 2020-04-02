Return-Path: <SRS0=lRhX=5S=lists.openwall.com=kernel-hardening-return-18389-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D06CC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 16:20:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E55B620737
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 16:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E55B620737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18389-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23658 invoked by uid 550); 2 Apr 2020 16:20:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21835 invoked from network); 2 Apr 2020 16:16:34 -0000
Date: Thu, 02 Apr 2020 21:46:12 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v8 2/7] powerpc/kprobes: Mark newly allocated probes as RO
To: linuxppc-dev@lists.ozlabs.org, Russell Currey <ruscur@russell.cc>
Cc: ajd@linux.ibm.com, dja@axtens.net, kernel-hardening@lists.openwall.com,
        npiggin@gmail.com
References: <20200402084053.188537-1-ruscur@russell.cc>
	<20200402084053.188537-2-ruscur@russell.cc>
In-Reply-To: <20200402084053.188537-2-ruscur@russell.cc>
MIME-Version: 1.0
User-Agent: astroid/v0.15-13-gb675b421
 (https://github.com/astroidmail/astroid)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
x-cbid: 20040216-0020-0000-0000-000003C05099
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040216-0021-0000-0000-00002218FCDC
Message-Id: <1585844035.o235bvxmq0.naveen@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_06:2020-04-02,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1011 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020131

Russell Currey wrote:
> With CONFIG_STRICT_KERNEL_RWX=3Dy and CONFIG_KPROBES=3Dy, there will be o=
ne
> W+X page at boot by default.  This can be tested with
> CONFIG_PPC_PTDUMP=3Dy and CONFIG_PPC_DEBUG_WX=3Dy set, and checking the
> kernel log during boot.
>=20
> powerpc doesn't implement its own alloc() for kprobes like other
> architectures do, but we couldn't immediately mark RO anyway since we do
> a memcpy to the page we allocate later.  After that, nothing should be
> allowed to modify the page, and write permissions are removed well
> before the kprobe is armed.
>=20
> The memcpy() would fail if >1 probes were allocated, so use
> patch_instruction() instead which is safe for RO.
>=20
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
>  arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.=
c
> index 81efb605113e..fa4502b4de35 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -24,6 +24,8 @@
>  #include <asm/sstep.h>
>  #include <asm/sections.h>
>  #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
> +#include <linux/vmalloc.h>
> =20
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe) =3D NULL;
>  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> @@ -102,6 +104,16 @@ kprobe_opcode_t *kprobe_lookup_name(const char *name=
, unsigned int offset)
>  	return addr;
>  }
> =20
> +void *alloc_insn_page(void)
> +{
> +	void *page =3D vmalloc_exec(PAGE_SIZE);
> +
> +	if (page)
> +		set_memory_ro((unsigned long)page, 1);
> +
> +	return page;
> +}
> +

This crashes for me with KPROBES_SANITY_TEST during the kretprobe test. =20
It seems to be handling the kretprobe itself properly, but seems to=20
crash on the return path. I haven't yet been able to work out what's=20
going wrong.

[    0.517880] Kprobe smoke test: started
[    0.626680] Oops: Exception in kernel mode, sig: 4 [#1]
[    0.626708] LE PAGE_SIZE=3D64K MMU=3DRadix SMP NR_CPUS=3D2048 NUMA Power=
NV
[    0.626735] Modules linked in:
[    0.626760] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-06592-g2e646=
94b9137 #51
[    0.626795] NIP:  c008000000020000 LR: c00000000021ce34 CTR: c0000000002=
1c5f8
[    0.626829] REGS: c0000000fd3e3860 TRAP: 0e40   Not tainted  (5.6.0-0659=
2-g2e64694b9137)
[    0.626862] MSR:  9000000002089433 <SF,HV,VEC,EE,ME,SE,IR,DR,RI,LE>  CR:=
 28000284  XER: 00040000
[    0.626922] CFAR: c00000000000ef20 IRQMASK: 0=20
[    0.626922] GPR00: c000000000052250 c0000000fd3e3af0 c000000002330200 00=
0000002db8ad86=20
[    0.626922] GPR04: 0000000000000000 c00000000006ba3c 0000000000000800 c0=
000000fd3a0000=20
[    0.626922] GPR08: 0000000000000000 ffffffffaaaaaaab c0000000fd3a0000 00=
00000040000000=20
[    0.626922] GPR12: c00000000021c5f0 c000000002520000 c000000000011790 00=
00000000000000=20
[    0.626922] GPR16: 0000000000000000 0000000000000000 0000000000000000 00=
00000000000000=20
[    0.626922] GPR20: 0000000000000000 0000000000000000 0000000000000000 00=
00000000000000=20
[    0.626922] GPR24: c0000000020034bc c0000000012068b8 c000000002062e50 c0=
000000fd2319a0=20
[    0.626922] GPR28: c000000000f5ebb0 0000000000000000 c0000000021bc278 c0=
00000002458540=20
[    0.627234] NIP [c008000000020000] 0xc008000000020000
[    0.627264] LR [c00000000021ce34] init_test_probes+0x424/0x560
[    0.627291] Call Trace:
[    0.627313] [c0000000fd3e3af0] [c00000000021ce34] init_test_probes+0x424=
/0x560 (unreliable)
[    0.627356] [c0000000fd3e3b90] [c00000000202de2c] init_kprobes+0x1a8/0x1=
c8
[    0.627392] [c0000000fd3e3c00] [c000000000011140] do_one_initcall+0x60/0=
x2b0
[    0.627432] [c0000000fd3e3cd0] [c000000002004674] kernel_init_freeable+0=
x2e0/0x3a0
[    0.627471] [c0000000fd3e3db0] [c0000000000117ac] kernel_init+0x24/0x178
[    0.627510] [c0000000fd3e3e20] [c00000000000c7a8] ret_from_kernel_thread=
+0x5c/0x74
[    0.627543] Instruction dump:
[    0.627562] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXX=
XX XXXXXXXX=20
[    0.627607] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX <00000000> 00000000 0000=
0000 00000000=20
[    0.627660] ---[ end trace 964ab92781f5d99d ]---
[    0.629607]=20


- Naveen


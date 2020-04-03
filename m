Return-Path: <SRS0=sl2d=5T=lists.openwall.com=kernel-hardening-return-18409-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7997C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 09:38:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 37C5020737
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 09:38:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37C5020737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18409-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19627 invoked by uid 550); 3 Apr 2020 09:38:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18232 invoked from network); 3 Apr 2020 09:36:46 -0000
Date: Fri, 03 Apr 2020 15:06:25 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v8 2/7] powerpc/kprobes: Mark newly allocated probes as RO
To: linuxppc-dev@lists.ozlabs.org, Russell Currey <ruscur@russell.cc>
Cc: ajd@linux.ibm.com, dja@axtens.net, kernel-hardening@lists.openwall.com,
        npiggin@gmail.com
References: <20200402084053.188537-1-ruscur@russell.cc>
	<20200402084053.188537-2-ruscur@russell.cc>
	<1585844035.o235bvxmq0.naveen@linux.ibm.com>
	<1585852977.oiikywo1jz.naveen@linux.ibm.com>
	<c336400d5b7765eb72b3090cd9f8a3c57761d0b6.camel@russell.cc>
In-Reply-To: <c336400d5b7765eb72b3090cd9f8a3c57761d0b6.camel@russell.cc>
MIME-Version: 1.0
User-Agent: astroid/v0.15-13-gb675b421
 (https://github.com/astroidmail/astroid)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
x-cbid: 20040309-0020-0000-0000-000003C0C2C6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040309-0021-0000-0000-00002219721C
Message-Id: <1585906281.fbqgtc3kpy.naveen@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_05:2020-04-02,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 phishscore=0 malwarescore=0 bulkscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030078

Russell Currey wrote:
> On Fri, 2020-04-03 at 00:18 +0530, Naveen N. Rao wrote:
>> Naveen N. Rao wrote:
>> > Russell Currey wrote:
>> > > With CONFIG_STRICT_KERNEL_RWX=3Dy and CONFIG_KPROBES=3Dy, there will
>> > > be one
>> > > W+X page at boot by default.  This can be tested with
>> > > CONFIG_PPC_PTDUMP=3Dy and CONFIG_PPC_DEBUG_WX=3Dy set, and checking
>> > > the
>> > > kernel log during boot.
>> > >=20
>> > > powerpc doesn't implement its own alloc() for kprobes like other
>> > > architectures do, but we couldn't immediately mark RO anyway
>> > > since we do
>> > > a memcpy to the page we allocate later.  After that, nothing
>> > > should be
>> > > allowed to modify the page, and write permissions are removed
>> > > well
>> > > before the kprobe is armed.
>> > >=20
>> > > The memcpy() would fail if >1 probes were allocated, so use
>> > > patch_instruction() instead which is safe for RO.
>> > >=20
>> > > Reviewed-by: Daniel Axtens <dja@axtens.net>
>> > > Signed-off-by: Russell Currey <ruscur@russell.cc>
>> > > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> > > ---
>> > >  arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
>> > >  1 file changed, 13 insertions(+), 4 deletions(-)
>> > >=20
>> > > diff --git a/arch/powerpc/kernel/kprobes.c
>> > > b/arch/powerpc/kernel/kprobes.c
>> > > index 81efb605113e..fa4502b4de35 100644
>> > > --- a/arch/powerpc/kernel/kprobes.c
>> > > +++ b/arch/powerpc/kernel/kprobes.c
>> > > @@ -24,6 +24,8 @@
>> > >  #include <asm/sstep.h>
>> > >  #include <asm/sections.h>
>> > >  #include <linux/uaccess.h>
>> > > +#include <linux/set_memory.h>
>> > > +#include <linux/vmalloc.h>
>> > > =20
>> > >  DEFINE_PER_CPU(struct kprobe *, current_kprobe) =3D NULL;
>> > >  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>> > > @@ -102,6 +104,16 @@ kprobe_opcode_t *kprobe_lookup_name(const
>> > > char *name, unsigned int offset)
>> > >  	return addr;
>> > >  }
>> > > =20
>> > > +void *alloc_insn_page(void)
>> > > +{
>> > > +	void *page =3D vmalloc_exec(PAGE_SIZE);
>> > > +
>> > > +	if (page)
>> > > +		set_memory_ro((unsigned long)page, 1);
>> > > +
>> > > +	return page;
>> > > +}
>> > > +
>> >=20
>> > This crashes for me with KPROBES_SANITY_TEST during the kretprobe
>> > test. =20
>>=20
>> That isn't needed to reproduce this. After bootup, disabling
>> optprobes=20
>> also shows the crash with kretprobes:
>> 	sysctl debug.kprobes-optimization=3D0
>>=20
>> The problem happens to be with patch_instruction() in=20
>> arch_prepare_kprobe(). During boot, on kprobe init, we register a
>> probe=20
>> on kretprobe_trampoline for use with kretprobes (see=20
>> arch_init_kprobes()). This results in an instruction slot being=20
>> allocated, and arch_prepare_kprobe() to be called for copying the=20
>> instruction (nop) at kretprobe_trampoline. patch_instruction() is=20
>> failing resulting in corrupt instruction which we try to
>> emulate/single=20
>> step causing the crash.
>=20
> OK I think I've fixed it, KPROBES_SANITY_TEST passes too.  I'd
> appreciate it if you could test v9, and thanks again for finding this -
> very embarrassing bug on my side.

Great! Thanks.

I think I should also add appropriate error checking to kprobes' use of=20
patch_instruction() which would have caught this much more easily.

On a related note, I notice that x86 seems to prefer not having any RWX=20
pages, and so they continue to do 'module_alloc()' followed by=20
'set_memory_ro()' and then 'set_memory_x()'. Is that something worth=20
following for powerpc?


- Naveen


Return-Path: <SRS0=NqEB=5T=lists.openwall.com=kernel-hardening-return-18411-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FC6C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 10:06:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 29E9E20757
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 10:06:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29E9E20757
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18411-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30427 invoked by uid 550); 3 Apr 2020 10:06:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30069 invoked from network); 3 Apr 2020 10:03:57 -0000
Date: Fri, 03 Apr 2020 15:33:35 +0530
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
	<1585906281.fbqgtc3kpy.naveen@linux.ibm.com>
	<02c6c3d0483e217a6d879bb7037f0b549c64ba04.camel@russell.cc>
In-Reply-To: <02c6c3d0483e217a6d879bb7037f0b549c64ba04.camel@russell.cc>
MIME-Version: 1.0
User-Agent: astroid/v0.15-13-gb675b421
 (https://github.com/astroidmail/astroid)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
x-cbid: 20040310-0008-0000-0000-00000369A365
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040310-0009-0000-0000-00004A8B32B0
Message-Id: <1585907769.yhied5pgqm.naveen@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_06:2020-04-02,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030082

Russell Currey wrote:
> On Fri, 2020-04-03 at 15:06 +0530, Naveen N. Rao wrote:
>> Russell Currey wrote:
>> > On Fri, 2020-04-03 at 00:18 +0530, Naveen N. Rao wrote:
>> > > Naveen N. Rao wrote:
>> > > > Russell Currey wrote:
>> > > > > =20
>> > > > > +void *alloc_insn_page(void)
>> > > > > +{
>> > > > > +	void *page =3D vmalloc_exec(PAGE_SIZE);
>> > > > > +
>> > > > > +	if (page)
>> > > > > +		set_memory_ro((unsigned long)page, 1);
>> > > > > +
>> > > > > +	return page;
>> > > > > +}
>> > > > > +
>> > > >=20
>> > > > This crashes for me with KPROBES_SANITY_TEST during the
>> > > > kretprobe
>> > > > test. =20
>> > >=20
>> > > That isn't needed to reproduce this. After bootup, disabling
>> > > optprobes=20
>> > > also shows the crash with kretprobes:
>> > > 	sysctl debug.kprobes-optimization=3D0
>> > >=20
>> > > The problem happens to be with patch_instruction() in=20
>> > > arch_prepare_kprobe(). During boot, on kprobe init, we register a
>> > > probe=20
>> > > on kretprobe_trampoline for use with kretprobes (see=20
>> > > arch_init_kprobes()). This results in an instruction slot being=20
>> > > allocated, and arch_prepare_kprobe() to be called for copying
>> > > the=20
>> > > instruction (nop) at kretprobe_trampoline. patch_instruction()
>> > > is=20
>> > > failing resulting in corrupt instruction which we try to
>> > > emulate/single=20
>> > > step causing the crash.
>> >=20
>> > OK I think I've fixed it, KPROBES_SANITY_TEST passes too.  I'd
>> > appreciate it if you could test v9, and thanks again for finding
>> > this -
>> > very embarrassing bug on my side.
>>=20
>> Great! Thanks.
>>=20
>> I think I should also add appropriate error checking to kprobes' use
>> of=20
>> patch_instruction() which would have caught this much more easily.
>=20
> Only kind of!  It turns out that if the initial setup fails for
> KPROBES_SANITY_TEST, it silently doesn't run - so you miss the "Kprobe
> smoke test" text, but you don't get any kind of error either.  I'll
> send a patch so that it fails more loudly later.

Ha, I see what you mean. Good catch, we should pass the kprobe init=20
status to the test and have it error out.

>=20
>>=20
>> On a related note, I notice that x86 seems to prefer not having any
>> RWX=20
>> pages, and so they continue to do 'module_alloc()' followed by=20
>> 'set_memory_ro()' and then 'set_memory_x()'. Is that something worth=20
>> following for powerpc?
>=20
> I just noticed that too.  arm64 doesn't set theirs executable, as far
> as I can tell powerpc doesn't need to.

I didn't follow that. We do need it to be executable so that we can=20
single step the original instruction.

arm64 does vmalloc_exec(), which looks like it sets the page to RWX,=20
then marks it RO. There is a small window where the page would be WX. =20
x86 instead seems to first allocate the page as RW, mark as RO, and only=20
then enable X - removing that small window where the page is both W and=20
X.

- Naveen


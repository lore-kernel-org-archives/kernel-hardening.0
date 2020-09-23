Return-Path: <SRS0=s4GM=DA=lists.openwall.com=kernel-hardening-return-19963-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4757CC4363D
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 06:55:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0DF7F2223E
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 06:55:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DF7F2223E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hotmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19963-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6032 invoked by uid 550); 23 Sep 2020 06:55:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26526 invoked from network); 23 Sep 2020 02:50:41 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/cU/RvWpFhTxPGDBXDryDr4yRJjOHoY64wki0TMh0yTlNcgOpl2w7HCq6VRyPng3M74eGkR2qRo7KlptUpMJszTgJxf97tg6BaRz0HIJ/cFTEDCVO658iV0p+YTSksLzKvDP13SZIJaiwHaDxtwDLYJgn6m5GyCcynOhrNT9PBgizh2Syd8v7JeGve4LypbTkdEKj6enD/WRJoG3JfTCuBRWeoaoSJzCFXyP5EW4YUX7a9HBZ8MolXuQSRhW5ghUdVbfVJtc0gVNtkWd3cb9VcOEo6oWs3jnMGHsCawqTw/VhJIqAx3wqrisUJsZJ3usTzxPVyQKCgdWIghZ8Uklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvTTnKCYGHurkxwfaKNb2lnLbAj4p4zT6NwURF5SYn0=;
 b=BstmEOPKm3uWzxWNFbN04lnBTeNLJoV7vipUNA8Ds1/GNBSFh1xb3NQxETgFnRVdtt3I+FkB0Z8VKG6CH3OqSV2QVqgy5QNUJofa/db0OAx+c4rJs+Gv4IWC3hN6XJnTUvH1MgF5gQdWFfSxJQ9cScaOFuSN6RAusLA/soL9922QK6/9bd5FwHGrGmNIsx4dnJPZ7XW33Pn4ThbIZ/NJOISQRglRl6YOehaqD87TcypmqRqz5ByHfz1brMqReSUHfxowxrHjInz1i0Q4oT9faGDUf+3WI8t7KpNULQedMKF/fkbqXlOhpNRoP0Tj0JrZ6ovVdmDnxI5ONPYy9uKLUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvTTnKCYGHurkxwfaKNb2lnLbAj4p4zT6NwURF5SYn0=;
 b=inwejhaMM/zi77pXXdlhOi1JHJ/ww/cvx7w5L2SL7yaUs5rGqderwlPVVv53BfWPIsiS5nYteXRCcWO1jfcPZ8sFTK00MvpYWYVwaYfSj66XVkOlI6LrL9L4mmA8g9tcN9gyHPL1kd4RJgE2dOjgJvx+nRNobalRXtMpFGW00O7spFkXnhVxQzYaVKfBJefsjo/aV8FWyEZq8vg1w2OxoI2DvYLvzmx0j4+TRb83ikH6NEHlOjtnDoTvK9v1oD/VSLGf4cZ1WmLC8+FaAqyU7GWmIq9uAWGdvKpsNMJlbt5viVNA7a8HOnG7jICystG+PppDNlpJ/zdSyKgOYaUGTw==
From: Jay K <jayk123@hotmail.com>
To: Florian Weimer <fw@deneb.enyo.de>, "Madhavan T. Venkataraman"
	<madvenka@linux.microsoft.com>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"oleg@redhat.com" <oleg@redhat.com>, "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "libffi-discuss@sourceware.org"
	<libffi-discuss@sourceware.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Jay (work)" <jaykrell@microsoft.com>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index: AQHWjI6KxyKJbt2Ptk2ZqEdXq+b+vqls92IAgAiWrKM=
Date: Wed, 23 Sep 2020 02:50:23 +0000
Message-ID:
 <MWHPR1401MB1951CF31B40DF202D3BCE2EEE6380@MWHPR1401MB1951.namprd14.prod.outlook.com>
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>,<96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
In-Reply-To: <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-incomingtopheadermarker:
 OriginalChecksum:EDFE919D6E26D58750D06E52F5DADB36825CC53A83CBB036CD36103A9036E4C5;UpperCasedChecksum:5B355A5694514BEEE8ECF72190F859F63136516A4AC6AB226585B2A354C6F088;SizeAsReceived:7836;Count:44
x-tmn: [jOwMV5a9OG8VMOnP3W7TtEvk5sOka3UYlZH3D2tYmakuCe152AnWujeas2EuH+Oo]
x-ms-publictraffictype: Email
x-incomingheadercount: 44
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: c24e5a92-6ef8-4d82-023a-08d85f6b6aea
x-ms-traffictypediagnostic: BN3NAM04HT126:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 fBx7N+CrTqWfNX4+Wtu/yjQy3FebDoHH8BaIKBxIvvEmbV5ogJ+U6mlDIWCFjKojomXhE2Oe9mj74fOwbsrp0RpH+hna9+gwMIIdd+Ii8AYnZWWw028G7TH7K/3jFhpvBSOgXhuaLCNI8AmywKD2hYma8L6VUrCtE29XOAgLOVEK+ygOjD2P7NqYAShTh/m7nZpeRVaz+EJk1pbeexilD/kEcmH+vzXprKlUojJUfUzSwjerS7wQzo2vVW9XG1zl
x-ms-exchange-antispam-messagedata:
 ysxequYLYCclF3nAObQPYVqajHYOa1DhKYDOnCO/Jx3IRSxfw2jSS8pE72Om5T9/XEWNXfM1BQ+nTFMNTuPLJa5OKw2tMU4QTo3X+iHurO5Fvbe4biMsx8Ett1hLmQ+UzfT1vwZlgrhLcy7rb7EYKe+IKJaRfhJCzjsXaeuMC+NDji4Jq9kZUOKPenT71UBqOzeUEFIQK2AlAI1P6bFSJA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hotmail.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-AuthSource: BN3NAM04FT052.eop-NAM04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c24e5a92-6ef8-4d82-023a-08d85f6b6aea
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 02:50:23.2235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3NAM04HT126

=A0 > As mentioned before, if the ISA supports PC-relative data references =
=0A=
=A0 > (e.g., X86 64-bit platforms support RIP-relative data references) =0A=
=A0 > then we can pass data to that code by placing the code and data in =
=A0=0A=
=A0 > adjacent pages. So, you can implement the trampoline table for X64.  =
=0A=
=A0 > i386 does not support it. =0A=
=0A=
i386 does not need this either.=0A=
=0A=
You make a PC-relative call, read the return address into a register, and t=
hen do register-relative data access.=0A=
=0A=
either: =0A=
=A0 call get_pc ; PC-relative call  =0A=
=A0 mov =A0eax, [eax+x] =0A=
 =0A=
get_pc: =0A=
=A0 mov eax, [esp] =0A=
=A0 ret =0A=
=0A=
or if you don't mind disrupting the return address predictor:=0A=
=0A=
=A0call +0  =0A=
=A0pop eax =A0 =0A=
=A0mov eax, [eax+x]  =0A=
=A0=0A=
where x is computed by the static linker, and eax can vary.=0A=
The same way PIC code normally works I think.=0A=
=0A=
Also the data and code do not have to be on adjacent pages in this scheme.=
=0A=
=0A=
You can just map an entire .dll/.so additional times.=0A=
=A0A little wasteful, yes, but quite convenient. Factor the thunks/trampoli=
nes=0A=
=A0into their own .so/.dll to make it not very wasteful.=0A=
=0A=
=0A=
The functions do not even have to be a fixed distance from their array elem=
ent either.=0A=
Architectures that are "naturally" position independent (amd64, arm64) do n=
ot even need any assembly to do this.=0A=
Just use C and stamp out multiple copies with the C preprocessor.=0A=
But arm32 and x86 do tend to need some assembly, depending on compilation m=
odel, etc. (i.e. on Windows at least).=0A=
=0A=
=0A=
Is there any architecture that lacks both PC-relative data access and PC-re=
lative call, with=0A=
ability to materialize the return address into a register?=0A=
=0A=
=0A=
Given codegen that is not "arbitrary", you make it "data driven" and you do=
n't need=0A=
kernel support. Unless there really exists architectures that cannot reason=
ably synthesize=0A=
PC-relative data access. ?=0A=
=0A=
=0A=
As long as you can use mmap or similar to map a .so/.dll any number of time=
s,=0A=
to produce any number of thunks.=0A=
=0A=
On Windows that this is CreateFileMapping(SEC_IMAGE) + MapViewOfFile.=0A=
i.e. not dlopen and not LoadLibrary, they just increment a reference count=
=0A=
and return the original mapping.=0A=
=0A=
=A0- Jay=0A=
=0A=
=0A=
From: Libffi-discuss <libffi-discuss-bounces@sourceware.org> on behalf of M=
adhavan T. Venkataraman via Libffi-discuss <libffi-discuss@sourceware.org>=
=0A=
Sent: Thursday, September 17, 2020 3:36 PM=0A=
To: Florian Weimer <fw@deneb.enyo.de>=0A=
Cc: kernel-hardening@lists.openwall.com <kernel-hardening@lists.openwall.co=
m>; linux-api@vger.kernel.org <linux-api@vger.kernel.org>; x86@kernel.org <=
x86@kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org=
>; oleg@redhat.com <oleg@redhat.com>; linux-security-module@vger.kernel.org=
 <linux-security-module@vger.kernel.org>; linux-fsdevel@vger.kernel.org <li=
nux-fsdevel@vger.kernel.org>; linux-integrity@vger.kernel.org <linux-integr=
ity@vger.kernel.org>; libffi-discuss@sourceware.org <libffi-discuss@sourcew=
are.org>; linux-arm-kernel@lists.infradead.org <linux-arm-kernel@lists.infr=
adead.org>=0A=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor =0A=
=A0=0A=
=0A=
=0A=
On 9/16/20 8:04 PM, Florian Weimer wrote:=0A=
> * madvenka:=0A=
> =0A=
>> Examples of trampolines=0A=
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>>=0A=
>> libffi (A Portable Foreign Function Interface Library):=0A=
>>=0A=
>> libffi allows a user to define functions with an arbitrary list of=0A=
>> arguments and return value through a feature called "Closures".=0A=
>> Closures use trampolines to jump to ABI handlers that handle calling=0A=
>> conventions and call a target function. libffi is used by a lot=0A=
>> of different applications. To name a few:=0A=
>>=0A=
>>=A0=A0=A0=A0=A0=A0 - Python=0A=
>>=A0=A0=A0=A0=A0=A0 - Java=0A=
>>=A0=A0=A0=A0=A0=A0 - Javascript=0A=
>>=A0=A0=A0=A0=A0=A0 - Ruby FFI=0A=
>>=A0=A0=A0=A0=A0=A0 - Lisp=0A=
>>=A0=A0=A0=A0=A0=A0 - Objective C=0A=
> =0A=
> libffi does not actually need this.=A0 It currently collocates=0A=
> trampolines and the data they need on the same page, but that's=0A=
> actually unecessary.=A0 It's possible to avoid doing this just by=0A=
> changing libffi, without any kernel changes.=0A=
> =0A=
> I think this has already been done for the iOS port.=0A=
> =0A=
=0A=
The trampoline table that has been implemented for the iOS port (MACH)=0A=
is based on PC-relative data referencing. That is, the code and data=0A=
are placed in adjacent pages so that the code can access the data using=0A=
an address relative to the current PC.=0A=
=0A=
This is an ISA feature that is not supported on all architectures.=0A=
=0A=
Now, if it is a performance feature, we can include some architectures=0A=
and exclude others. But this is a security feature. IMO, we cannot=0A=
exclude any architecture even if it is a legacy one as long as Linux=0A=
is running on the architecture. So, we need a solution that does=0A=
not assume any specific ISA feature.=0A=
=0A=
>> The code for trampoline X in the trampoline table is:=0A=
>>=0A=
>>=A0=A0=A0=A0=A0=A0 load=A0=A0=A0 &code_table[X], code_reg=0A=
>>=A0=A0=A0=A0=A0=A0 load=A0=A0=A0 (code_reg), code_reg=0A=
>>=A0=A0=A0=A0=A0=A0 load=A0=A0=A0 &data_table[X], data_reg=0A=
>>=A0=A0=A0=A0=A0=A0 load=A0=A0=A0 (data_reg), data_reg=0A=
>>=A0=A0=A0=A0=A0=A0 jump=A0=A0=A0 code_reg=0A=
>>=0A=
>> The addresses &code_table[X] and &data_table[X] are baked into the=0A=
>> trampoline code. So, PC-relative data references are not needed. The use=
r=0A=
>> can modify code_table[X] and data_table[X] dynamically.=0A=
> =0A=
> You can put this code into the libffi shared object and map it from=0A=
> there, just like the rest of the libffi code.=A0 To get more=0A=
> trampolines, you can map the page containing the trampolines multiple=0A=
> times, each instance preceded by a separate data page with the control=0A=
> information.=0A=
> =0A=
=0A=
If you put the code in the libffi shared object, how do you pass data to=0A=
the code at runtime? If the code we are talking about is a function, then=
=0A=
there is an ABI defined way to pass data to the function. But if the=0A=
code we are talking about is some arbitrary code such as a trampoline,=0A=
there is no ABI defined way to pass data to it except in a couple of=0A=
platforms such as HP PA-RISC that have support for function descriptors=0A=
in the ABI itself.=0A=
=0A=
As mentioned before, if the ISA supports PC-relative data references=0A=
(e.g., X86 64-bit platforms support RIP-relative data references)=0A=
then we can pass data to that code by placing the code and data in=0A=
adjacent pages. So, you can implement the trampoline table for X64.=0A=
i386 does not support it.=0A=
=0A=
=0A=
> I think the previous patch submission has also resulted in several=0A=
> comments along those lines, so I'm not sure why you are reposting=0A=
> this.=0A=
=0A=
IIRC, I have answered all of those comments by mentioning the point=0A=
that we need to support all architectures without requiring special=0A=
ISA features. Taking the kernel's help in this is one solution.=0A=
=0A=
=0A=
> =0A=
>> libffi=0A=
>> =3D=3D=3D=3D=3D=3D=0A=
>>=0A=
>> I have implemented my solution for libffi and provided the changes for=
=0A=
>> X86 and ARM, 32-bit and 64-bit. Here is the reference patch:=0A=
>>=0A=
>> https://nam10.safelinks.protection.outlook.com/?url=3Dhttp:%2F%2Flinux.m=
icrosoft.com%2F~madvenka%2Flibffi%2Flibffi.v2.txt&amp;data=3D02%7C01%7C%7C2=
5b693de3de342e1e02c08d85b1f6af5%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%=
7C637359537776320186&amp;sdata=3Db%2BqpgrUoSy%2FrprtE4xgd0%2FhPiFxTOh69yYjl=
TkgSQoc%3D&amp;reserved=3D0=0A=
> =0A=
> The URL does not appear to work, I get a 403 error.=0A=
=0A=
I apologize for that. That site is supposed to be accessible publicly.=0A=
I will contact the administrator and get this resolved.=0A=
=0A=
Sorry for the annoyance.=0A=
=0A=
> =0A=
>> If the trampfd patchset gets accepted, I will send the libffi changes=0A=
>> to the maintainers for a review. BTW, I have also successfully executed=
=0A=
>> the libffi self tests.=0A=
> =0A=
> I have not seen your libffi changes, but I expect that the complexity=0A=
> is about the same as a userspace-only solution.=0A=
> =0A=
> =0A=
=0A=
I agree. The complexity is about the same. But the support is for all=0A=
architectures. Once the common code is in place, the changes for each=0A=
architecture are trivial.=0A=
=0A=
Madhavan=0A=
=0A=
> Cc:ing libffi upstream for awareness.=A0 The start of the thread is=0A=
> here:=0A=
> =0A=
> <https://nam10.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore=
.kernel.org%2Flinux-api%2F20200916150826.5990-1-madvenka%40linux.microsoft.=
com%2F&amp;data=3D02%7C01%7C%7C25b693de3de342e1e02c08d85b1f6af5%7C84df9e7fe=
9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637359537776320186&amp;sdata=3DnIIDBh6F%2=
Fit%2BklEWLzuy0iiKCCf%2BxRf4JNZS8LbFkOY%3D&amp;reserved=3D0>=0A=
> =

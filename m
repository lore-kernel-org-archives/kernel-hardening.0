Return-Path: <SRS0=hwwU=ZL=lists.openwall.com=kernel-hardening-return-17402-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C541C43141
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 21:55:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5B54B22440
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 21:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="S7oclRU2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B54B22440
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17402-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24078 invoked by uid 550); 19 Nov 2019 21:54:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24052 invoked from network); 19 Nov 2019 21:54:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=hoL0Q3ubpB2UZhUFNnAh7oF1P1juzLtPY91tbnV5tGk=;
        b=S7oclRU2LYyN43o2tbAd+BlrjF5hdF3fb9OmqGsihHV+jqCnSDuSWWpwAhGIhYCvIn
         uj+0+z84x+V8SnOvGX3tAXIiVJq2guO+9/DV7t796hF0WyCLE+E1zWdujVAJiwTQUZ9f
         v7l6zWmzeRtffv3579woBaNMBynYUmRyUAxqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=hoL0Q3ubpB2UZhUFNnAh7oF1P1juzLtPY91tbnV5tGk=;
        b=FK2+wou2Infi5FWpTVBaNdDH0VuYkvdDzZjLpxZ6Kyg2aVIFIuRLB/DDbZXm/Q20ib
         nlWdEc4Zp45kEjpf+oKUI6g/EBqPcCdi/KCI2gDdoYS7/luNSCrkwzk2NoBdqj0a0gtX
         JzzxSRb6pBNfRWfRIpZDm4Nw+yYmKSesf0IpZ22hZ+F7iOS1QcoowyTdtGIaOdkNR1f7
         VL3EO3syaHnmfZyl5P+qB7esw++Rq1PxqOgMMAZ6Qp/TRe1ripqXWz5xE3RA5MsXp9hp
         TM7BGcVTLgh0DyUS1c3KK8khrljl9cc7wQKMtnm8OwULf5PKzLo+y+2S5jum7Vaqeh/q
         mCOg==
X-Gm-Message-State: APjAAAVYXTui+mkjH38LxDHOV1G370twN/b8R2TJ0Vya1DamG4Snpq5G
	aMJqiT59VjpD/FOL1itBMIJn
X-Google-Smtp-Source: APXvYqyAnqpWvPGxRJUSssj+gGRYwSnhAFSPOKBKamy7/MGBLJp2y/UK9lbaUKLs36wb/i9XBB7YUg==
X-Received: by 2002:a05:6a00:10:: with SMTP id h16mr8702188pfk.27.1574200486927;
        Tue, 19 Nov 2019 13:54:46 -0800 (PST)
From: Tianlin Li <tli@digitalocean.com>
Message-Id: <16D5632C-27F1-4B9C-9255-A0B67582623D@digitalocean.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_426C217F-D6FC-481B-8A38-8D712411F2B1"
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC PATCH] kernel/module: have the callers of set_memory_*()
 check the return value
Date: Tue, 19 Nov 2019 15:54:44 -0600
In-Reply-To: <20191119213854.GP3079@worktop.programming.kicks-ass.net>
Cc: kernel-hardening@lists.openwall.com,
 Kees Cook <keescook@chromium.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ingo Molnar <mingo@redhat.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Greentime Hu <green.hu@gmail.com>,
 Vincent Chen <deanbo422@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>,
 "H . Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org,
 Jessica Yu <jeyu@kernel.org>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
References: <20191119155149.20396-1-tli@digitalocean.com>
 <20191119213854.GP3079@worktop.programming.kicks-ass.net>
X-Mailer: Apple Mail (2.3445.104.11)


--Apple-Mail=_426C217F-D6FC-481B-8A38-8D712411F2B1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Nov 19, 2019, at 3:38 PM, Peter Zijlstra <peterz@infradead.org> =
wrote:
>=20
> On Tue, Nov 19, 2019 at 09:51:49AM -0600, Tianlin Li wrote:
>> Right now several architectures allow their set_memory_*() family of=20=

>> functions to fail, but callers may not be checking the return values. =
We=20
>> need to fix the callers and add the __must_check attribute. They also =
may
>> not provide any level of atomicity, in the sense that the memory=20
>> protections may be left incomplete on failure. This issue likely has =
a few=20
>> steps on effects architectures[1]:
>> 1)Have all callers of set_memory_*() helpers check the return value.
>> 2)Add __much_check to all set_memory_*() helpers so that new uses do =
not=20
>> ignore the return value.
>> 3)Add atomicity to the calls so that the memory protections aren't =
left in=20
>> a partial state.
>>=20
>> Ideally, the failure of set_memory_*() should be passed up the call =
stack,=20
>> and callers should examine the failure and deal with it. But =
currently,=20
>> some callers just have void return type.
>>=20
>> We need to fix the callers to handle the return all the way to the =
top of=20
>> stack, and it will require a large series of patches to finish all =
the three=20
>> steps mentioned above. I start with kernel/module, and will move onto =
other=20
>> subsystems. I am not entirely sure about the failure modes for each =
caller.=20
>> So I would like to get some comments before I move forward. This =
single=20
>> patch is just for fixing the return value of set_memory_*() function =
in=20
>> kernel/module, and also the related callers. Any feedback would be =
greatly=20
>> appreciated.
>=20
> Please have a look here:
>=20
>  https://lkml.kernel.org/r/20191111131252.921588318@infradead.org =
<https://lkml.kernel.org/r/20191111131252.921588318@infradead.org>
>=20
> Much of the code you're patching is slated for removal.
>=20
> Josh also has patches reworking KLP and there's some ARM64 patches
> pending at which point we can also delete module_disable_ro().
Thanks for the information. I will check the code.=20=

--Apple-Mail=_426C217F-D6FC-481B-8A38-8D712411F2B1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><br =
class=3D""><div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D"">On Nov 19, 2019, at 3:38 PM, Peter Zijlstra &lt;<a =
href=3D"mailto:peterz@infradead.org" =
class=3D"">peterz@infradead.org</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">On Tue, Nov 19, 2019 at =
09:51:49AM -0600, Tianlin Li wrote:</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D"">Right now several architectures allow =
their set_memory_*() family of<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">functions to =
fail, but callers may not be checking the return values. We<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">need to fix =
the callers and add the __must_check attribute. They also may<br =
class=3D"">not provide any level of atomicity, in the sense that the =
memory<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">protections may be left incomplete on failure. This issue =
likely has a few<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">steps on effects architectures[1]:<br class=3D"">1)Have all =
callers of set_memory_*() helpers check the return value.<br =
class=3D"">2)Add __much_check to all set_memory_*() helpers so that new =
uses do not<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">ignore the return value.<br class=3D"">3)Add atomicity to the =
calls so that the memory protections aren't left in<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">a partial =
state.<br class=3D""><br class=3D"">Ideally, the failure of =
set_memory_*() should be passed up the call stack,<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">and callers =
should examine the failure and deal with it. But currently,<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">some callers =
just have void return type.<br class=3D""><br class=3D"">We need to fix =
the callers to handle the return all the way to the top of<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">stack, and =
it will require a large series of patches to finish all the three<span =
class=3D"Apple-converted-space">&nbsp;</span><br class=3D"">steps =
mentioned above. I start with kernel/module, and will move onto =
other<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">subsystems. I am not entirely sure about the failure modes =
for each caller.<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">So I would like to get some comments before I move forward. =
This single<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">patch is just for fixing the return value of set_memory_*() =
function in<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">kernel/module, and also the related callers. Any feedback =
would be greatly<span class=3D"Apple-converted-space">&nbsp;</span><br =
class=3D"">appreciated.<br class=3D""></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Please have a look =
here:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">&nbsp;</span><a=
 href=3D"https://lkml.kernel.org/r/20191111131252.921588318@infradead.org"=
 style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px;" =
class=3D"">https://lkml.kernel.org/r/20191111131252.921588318@infradead.or=
g</a><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">Much of the =
code you're patching is slated for removal.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Josh also has patches reworking =
KLP and there's some ARM64 patches</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">pending at which point we can also delete =
module_disable_ro().</span></div></blockquote></div>Thanks for the =
information. I will check the code.&nbsp;</body></html>=

--Apple-Mail=_426C217F-D6FC-481B-8A38-8D712411F2B1--

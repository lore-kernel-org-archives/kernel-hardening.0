Return-Path: <SRS0=nnYe=BU=lists.openwall.com=kernel-hardening-return-19576-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF6CC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 17:21:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B8DAC2073E
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 17:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eKPSTUjY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8DAC2073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19576-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32522 invoked by uid 550); 10 Aug 2020 17:21:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32496 invoked from network); 10 Aug 2020 17:21:03 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 455EC20B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1597080050;
	bh=QztRxjg5Vzn1+BhRWbvEoQob7TnJVf+LDWR1fdGK1RI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=eKPSTUjYobtjmzMeCI6PkxNCfKJz7ro7VXXbqVEYYT//hXCKDwrkPu52A1AQP37iy
	 lDKCM6xskNsh+Ys8mPd0GiDHCqvNE84+LjsYcy1AC8zB5DJa34hXEGqJCulOGFc4Be
	 dteE4bazwCubkOLAa01dBpxjq7OF88RfBUTcyHoA=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 linux-integrity <linux-integrity@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <3b916198-3a98-bd19-9a1c-f2d8d44febe8@linux.microsoft.com>
 <CALCETrUJ2hBmJujyCtEqx4=pknRvjvi1-Gj9wfRcMMzejjKQsQ@mail.gmail.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <04327056-cf4d-d547-4ec3-babd9603d384@linux.microsoft.com>
Date: Mon, 10 Aug 2020 12:20:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrUJ2hBmJujyCtEqx4=pknRvjvi1-Gj9wfRcMMzejjKQsQ@mail.gmail.com>
Content-Type: multipart/alternative;
 boundary="------------F4B928EBBF1A430715A76293"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------F4B928EBBF1A430715A76293
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Here is a redefinition of trampfd based on review comments.

I wanted to address dynamic code in 3 different ways:

    Remove the need for dynamic code where possible
    --------------------------------------------------------------------

    If the kernel itself can perform the work of some dynamic code, then
    the code can be replaced by the kernel.

    This is what I implemented in the patchset. But reviewers objected
    to the performance impact. One trip to the kernel was needed for each
    trampoline invocation. So, I have decided to defer this approach.

    Convert dynamic code to static code where possible
    ----------------------------------------------------------------------

    This is possible with help from the kernel. This has no performance
    impact and can be used in libffi, GCC nested functions, etc. I have
    described the approach below.

    Deal with code generation
    -----------------------------------

    For cases like generating JIT code from Java byte code, I wanted to
    establish a framework. However, reviewers felt that details are missing.

    Should the kernel generate code or should it use a user-level code generator?
    How do you make sure that a user level code generator can be trusted?
    How would the communication work? ABI details? Architecture support?
    Support for different types - JIT, DBT, etc?

    I have come to the conclusion that this is best done separately.

My main interest is to provide a way to convert dynamic code such as
trampolines to static code without any special architecture support.
This can be done with the kernel's help. Any code that gets written in
the future can conform to this as well.

So, in version 2 of the Trampfd RFC, I would like to simplify trampfd and
just address item 2. I will reimplement the support in libffi and present it.

Convert dynamic code to static code
------------------------------------------------

One problem with dynamic code is that it cannot be verified or authenticated
by the kernel. The kernel cannot tell the difference between genuine dynamic
code and an attacker's code. Where possible, dynamic code should be converted
to static code and placed in the text segment of a binary file. This allows
the kernel to verify the code by verifying the signature of the file.

The other problem is using user-level methods to load and execute dynamic code
can potentially be exploited by an attacker to inject his code and have it be
executed. To prevent this, a system may enforce W^X. If W^X is enforced
properly, genuine dynamic code will not be able to run. This is another
reason to convert dynamic code to static code.

The issue in converting dynamic code to static code is that the data is
dynamic. The code does not know before hand where the data is going to be
at runtime.

Some architectures support PC-relative data references. So, if you co-locate
code and data, then the code can find the data at runtime. But this is not
supported on all architectures. When supported, there may be limitations to
deal with. Plus you have to take the trouble to co-locate code and data.
And, to deal with W^X, code and data need to be in different pages.

All architectures must be supported without any limitations. Fortunately,
the kernel can solve this problem quite easily. I suggest the following:

Convert dynamic code to static code like this:

    - Decide which register should point to the data that the code needs.
      Call it register R.

    - Write the static code assuming that R already points to the data.

    - Use trampfd and pass the following to the kernel:

        - pointers to the code and data
        - the name of the register R

The kernel will write the following instructions in a trampoline page
mapped into the caller's address space with R-X.

    - Load the data address in register R
    - Jump to the static code

Basically, the kernel provides a trampoline to jump to the user's code
and returns the kernel-provided trampoline's address to the user.

It is trivial to implement a trampoline table in the trampoline page to
conserve memory.

Issues raised previously
-------------------------------

I believe that the following issues that were raised by reviewers is not
a problem in this scheme. Please rereview.

    - Florian mentioned the libffi trampoline table. Trampoline tables can be
      implemented in this scheme easily.

    - Florian mentioned stack unwinders. I am not an expert on unwinders.
      But I don't see an issue with unwinders.

    - Mark Rutland mentioned Intel's CET and CFI. Don't see a problem there.

    - Mark Rutland mentioned PAC+BTI on ARM64. Don't see a problem there.

If I have missed addressing any previously raised issue, I apologize.
Please let me know.

Thanks!

Madhavan

--------------F4B928EBBF1A430715A76293
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    Here is a redefinition of trampfd based on review comments.
    <pre style="color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial; overflow-wrap: break-word; white-space: pre-wrap;">
</pre>
    I wanted to address dynamic code in 3 different ways:<br>
    <br>
        Remove the need for dynamic code where possible<br>
       
    --------------------------------------------------------------------<br>
    <br>
        If the kernel itself can perform the work of some dynamic code,
    then<br>
        the code can be replaced by the kernel.<br>
    <br>
        This is what I implemented in the patchset. But reviewers
    objected<br>
        to the performance impact. One trip to the kernel was needed for
    each
    <br>
        trampoline invocation. So, I have decided to defer this
    approach.<br>
    <br>
        Convert dynamic code to static code where possible<br>
       
    ----------------------------------------------------------------------<br>
    <br>
        This is possible with help from the kernel. This has no
    performance<br>
        impact and can be used in libffi, GCC nested functions, etc. I
    have<br>
        described the approach below.<br>
    <br>
        Deal with code generation<br>
        -----------------------------------<br>
    <br>
        For cases like generating JIT code from Java byte code, I wanted
    to<br>
        establish a framework. However, reviewers felt that details are
    missing.<br>
    <br>
        Should the kernel generate code or should it use a user-level
    code generator?<br>
        How do you make sure that a user level code generator can be
    trusted?<br>
        How would the communication work? ABI details? Architecture
    support?<br>
        Support for different types - JIT, DBT, etc?<br>
    <br>
        I have come to the conclusion that this is best done separately.<br>
    <br>
    My main interest is to provide a way to convert dynamic code such as<br>
    trampolines to static code without any special architecture support.<br>
    This
    can be done with the kernel's help. Any code that gets written in<br>
    the future can conform to this as well.<br>
    <br>
    So, in version 2 of the Trampfd RFC, I would like to simplify
    trampfd and<br>
    just address item 2. I will reimplement the support in libffi and
    present it.<br>
    <br>
    Convert dynamic code to static code<br>
    ------------------------------------------------<br>
    <br>
    One problem with dynamic code is that it cannot be verified or
    authenticated<br>
    by the kernel. The kernel cannot tell the difference between genuine
    dynamic<br>
    code and an attacker's code. Where possible, dynamic code should be
    converted<br>
    to static code and placed in the text segment of a binary file. This
    allows<br>
    the kernel to verify the code by verifying the signature of the
    file.<br>
    <br>
    The other problem is using user-level methods to load and execute
    dynamic code<br>
    can potentially be exploited by an attacker to inject his code and
    have it be<br>
    executed. To prevent this, a system may enforce W^X. If W^X is
    enforced<br>
    properly, genuine dynamic code will not be able to run. This is
    another<br>
    reason to convert dynamic code to static code.<br>
    <br>
    The issue in converting dynamic code to static code is that the data
    is<br>
    dynamic. The code does not know before hand where the data is going
    to be<br>
    at
    runtime.
    <br>
    <br>
    Some architectures support PC-relative data references. So, if you
    co-locate<br>
    code and data, then the code can find the data at runtime. But this
    is not<br>
    supported on all architectures. When supported, there may be
    limitations to<br>
    deal with. Plus you have to take the trouble to co-locate code and
    data.<br>
    And, to deal with W^X, code and data need to be in different pages.<br>
    <br>
    All architectures must be supported without any limitations.
    Fortunately,<br>
    the kernel can solve this problem quite easily. I suggest the
    following:<br>
    <br>
    Convert dynamic code to static code like this:<br>
    <br>
        - Decide which register should point to the data that the code
    needs.<br>
          Call it register R.<br>
    <br>
        - Write the static code assuming that R already points to the
    data.<br>
    <br>
        - Use trampfd and pass the following to the kernel:
    <br>
    <br>
            - pointers to the code and data<br>
            - the name of the register R<br>
    <br>
    The kernel will write the following instructions in a trampoline
    page<br>
    mapped into the caller's address space with R-X.
    <br>
    <br>
        - Load the data address in register R<br>
        - Jump to the static code<br>
    <br>
    Basically, the kernel provides a trampoline to jump to the user's
    code<br>
    and returns the kernel-provided trampoline's address to the user.<br>
    <br>
    It is trivial to implement a trampoline table in the trampoline page
    to<br>
    conserve memory.<br>
    <br>
    Issues raised previously<br>
    -------------------------------<br>
    <br>
    I believe that the following issues that were raised by reviewers is
    not<br>
    a problem in this scheme. Please rereview.<br>
    <br>
        - Florian mentioned the libffi trampoline table. Trampoline
    tables can be<br>
          implemented in this scheme easily.<br>
    <br>
        - Florian mentioned stack unwinders. I am not an expert on
    unwinders.<br>
          But I don't see an issue with unwinders.<br>
    <br>
        - Mark Rutland mentioned Intel's CET and CFI. Don't see a
    problem there.<br>
    <br>
        - Mark Rutland mentioned PAC+BTI on ARM64.
    Don't see a problem there.<br>
    <br>
    If I have missed addressing any previously raised issue, I
    apologize.<br>
    Please let me know.<br>
    <br>
    Thanks!<br>
    <br>
    Madhavan<br>
  </body>
</html>

--------------F4B928EBBF1A430715A76293--

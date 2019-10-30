Return-Path: <SRS0=HCJk=YX=lists.openwall.com=kernel-hardening-return-17173-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAA3CA9EC5
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 19:17:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9A5A5204FD
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 19:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Wmz4BN9I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A5A5204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17173-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15613 invoked by uid 550); 30 Oct 2019 19:16:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15578 invoked from network); 30 Oct 2019 19:16:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SkNeb7N/RtOHBRU9IGeZjCb9lUHhzMvIRm1lPkdmY94=;
        b=Wmz4BN9I7WolTdUk59TZOxzjMRRja95bL9zO5kOJ57UJdIVxIrDaZMbHW4erd4Fros
         2hPOZirzIw1BFU5a69eAT/lwCab1RZEA7hAgyA5U3O0Nm8S/HI/c6oEUtgJbTHYu6Fbg
         su7wV2pd4MglPXtDzkpNzhd21Spi3W0VbfdXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SkNeb7N/RtOHBRU9IGeZjCb9lUHhzMvIRm1lPkdmY94=;
        b=YdKJVPs3elKE8Iv+Xc9onhlTYg+LhaU+UmBEXQrxJA/P3o5/vdx2vJWpR17hoM8iiX
         68RGdZLAKgrWbBwqho65jdVKpH0h9GABPJtruIVCHFpkgXeSD3a4jvSZ96EaLb6fO2he
         Z8nBJXYw5HDfam7tcZtJsYiPn1APV13ZUJpok3uo/u+5McOBp1fJgtbRCVItuIZqz2Uy
         lhCttrFDVsQ1dQbUvI4s6fEnci/uNHR46f4Q+rRT0Kbnq5Ni3mnNv5eSbGLjtL7q2a4h
         JJH12ZmBYm9x4y9JLRZkMmSYoUELdLExks4ZlBKvNSY1fL59BGVkYonnPfyxatLEOFHI
         sbYg==
X-Gm-Message-State: APjAAAVXFcbNkMr5+c8qkwC5hbNIzdmyaqvhbzOjT7n0PVb9z5gin3mt
	RXt/1hqaHcJvZmVAfrevHihiLA==
X-Google-Smtp-Source: APXvYqxfh9ztLk2WfEQDJ7irJePRmGVvoJEr3DPY5+qzc1/dbiyg9erl6+par2Vm529nXY8KHdViig==
X-Received: by 2002:aa7:9157:: with SMTP id 23mr982679pfi.73.1572463001813;
        Wed, 30 Oct 2019 12:16:41 -0700 (PDT)
Date: Wed, 30 Oct 2019 12:16:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jann Horn <jannh@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	kernel-hardening@lists.openwall.com,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/6] kselftest: Add test runner creation script
Message-ID: <201910301216.5C3F9BA010@keescook>
References: <20190405015859.32755-1-tobin@kernel.org>
 <20190405015859.32755-3-tobin@kernel.org>
 <CA+G9fYsfJpXQvOvHdjtg8z4a89dSStOQZOKa9zMjjQgWKng1aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsfJpXQvOvHdjtg8z4a89dSStOQZOKa9zMjjQgWKng1aw@mail.gmail.com>

On Wed, Oct 30, 2019 at 06:15:22PM +0530, Naresh Kamboju wrote:
> Hi Tobin,
> 
> On Fri, 5 Apr 2019 at 07:30, Tobin C. Harding <tobin@kernel.org> wrote:
> >
> > Currently if we wish to use kselftest to run tests within a kernel
> > module we write a small script to load/unload and do error reporting.
> > There are a bunch of these under tools/testing/selftests/lib/ that are
> > all identical except for the test name.  We can reduce code duplication
> > and improve maintainability if we have one version of this.  However
> > kselftest requires an executable for each test.  We can move all the
> > script logic to a central script then have each individual test script
> > call the main script.
> >
> > Oneliner to call kselftest_module.sh courtesy of Kees, thanks!
> >
> > Add test runner creation script.  Convert
> > tools/testing/selftests/lib/*.sh to use new test creation script.
> >
> > Testing
> > -------
> >
> > Configure kselftests for lib/ then build and boot kernel.  Then run
> > kselftests as follows:
> >
> >   $ cd /path/to/kernel/tree
> >   $ sudo make O=$output_path -C tools/testing/selftests TARGETS="lib" run_tests
> 
> We are missing "kselftest_module.sh" file when we do "make install"
> and followed by generating a tar file "gen_kselftest_tar.sh" and
> copying that on to target device and running tests by using
> "run_kselftest.sh" script file on the target.

Yikes -- there's a problem with gen_kselftest_tar.sh using the wrong
directory. I'll send a patch...

-Kees

> 
> Could you install the supporting script file "kselftest_module.sh" ?
> 
> Error log,
> -------------
> # selftests lib printf.sh
> lib: printf.sh_ #
> # ./printf.sh line 4 ./../kselftest_module.sh No such file or directory
> line: 4_./../kselftest_module.sh #
> [FAIL] 1 selftests lib printf.sh # exit=127
> selftests: lib_printf.sh [FAIL]
> # selftests lib bitmap.sh
> lib: bitmap.sh_ #
> # ./bitmap.sh line 3 ./../kselftest_module.sh No such file or directory
> line: 3_./../kselftest_module.sh #
> [FAIL] 2 selftests lib bitmap.sh # exit=127
> selftests: lib_bitmap.sh [FAIL]
> # selftests lib prime_numbers.sh
> lib: prime_numbers.sh_ #
> # ./prime_numbers.sh line 4 ./../kselftest_module.sh No such file or directory
> line: 4_./../kselftest_module.sh #
> [FAIL] 3 selftests lib prime_numbers.sh # exit=127
> selftests: lib_prime_numbers.sh [FAIL]
> # selftests lib strscpy.sh
> lib: strscpy.sh_ #
> # ./strscpy.sh line 3 ./../kselftest_module.sh No such file or directory
> line: 3_./../kselftest_module.sh #
> [FAIL] 4 selftests lib strscpy.sh # exit=127
> selftests: lib_strscpy.sh [FAIL]
> 
> - Naresh

-- 
Kees Cook

Return-Path: <SRS0=Yc73=O4=lists.openwall.com=kernel-hardening-return-21433-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BF5C433EF
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 22:44:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CE2EB60FDC
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 22:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CE2EB60FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 24421 invoked by uid 550); 8 Oct 2021 22:44:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24401 invoked from network); 8 Oct 2021 22:44:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=umB4uHDtxas96hN3BYGazDncxiBbCFqWtzPGIWT7LNc=;
        b=c1dhZkFOhudh2wXNpMdEc1RhSuvtxZ61MbgjOfWirI1dGCwop+oMrikrazWSKtARVC
         En1rtRySSqXcNiYt5ShEmep6JLQBztsQI2fOfwoUK2FMSMB0/TCaYAhtCuHAYoxM3HyE
         tmEzHJmoyWeedVttNjcYA9jyYFHoIa3v03c68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=umB4uHDtxas96hN3BYGazDncxiBbCFqWtzPGIWT7LNc=;
        b=gnS/Qi3hFBmUJ5cn9003yNKOGy6gBd952A5kP5fs4Jr6vAjE5H5ceEj7a9oYj/EeR8
         Hz4EFZkhmD3ZGDbI1uZYHRSFqIKZlALMdwIAZeYjndb77KJFDTXOd044+K4x+dx1iNJG
         ZYT7GVU2nS6itG6utnLJClAhS3jgKvTqj2bL1/qANBMD7mhcxHCtOyAd5YcliVoomek3
         y6cErenPGcLY/da0GpP5Fxr/xOAbK865seDVrJKjIxLbJYHO9ILTmDe8lL4R1tMFfmiW
         xuskJSI0ohgAeTUt3hWeBOz7MCiJK7rw6fJmtU53ZqcJ4hfBRPblzC+HBQ0FC4q2spcN
         7FLQ==
X-Gm-Message-State: AOAM532LookyOgnqGGK0rTrwXR9k5xnOa5OlWexW6XjO9Up60Dw20LYq
	D2EVWx2XRjG9BfIlf9UVRYmjxw==
X-Google-Smtp-Source: ABdhPJzCE+sLyU3dUaPPb1F+N9g3sYRtHexnhsIzGXBB0pFPvAIgLQ1uow9VWdB0524+rTctfRRdQA==
X-Received: by 2002:a62:ed0a:0:b0:44b:3f50:c4d4 with SMTP id u10-20020a62ed0a000000b0044b3f50c4d4mr12467574pfh.33.1633733061403;
        Fri, 08 Oct 2021 15:44:21 -0700 (PDT)
Date: Fri, 8 Oct 2021 15:44:20 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v13 3/3] selftest/interpreter: Add tests for
 trusted_for(2) policies
Message-ID: <202110081543.1B6BF22@keescook>
References: <20211007182321.872075-1-mic@digikod.net>
 <20211007182321.872075-4-mic@digikod.net>
 <202110071227.669B5A91C@keescook>
 <b1599775-a061-6c91-03a4-c82734c7f58c@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1599775-a061-6c91-03a4-c82734c7f58c@digikod.net>

On Fri, Oct 08, 2021 at 12:21:12PM +0200, Mickaël Salaün wrote:
> 
> On 07/10/2021 21:48, Kees Cook wrote:
> > On Thu, Oct 07, 2021 at 08:23:20PM +0200, Mickaël Salaün wrote:
> 
> [...]
> 
> >> diff --git a/tools/testing/selftests/interpreter/Makefile b/tools/testing/selftests/interpreter/Makefile
> >> new file mode 100644
> >> index 000000000000..1f71a161d40b
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/interpreter/Makefile
> >> @@ -0,0 +1,21 @@
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +
> >> +CFLAGS += -Wall -O2
> >> +LDLIBS += -lcap
> >> +
> >> +src_test := $(wildcard *_test.c)
> >> +TEST_GEN_PROGS := $(src_test:.c=)
> >> +
> >> +KSFT_KHDR_INSTALL := 1
> >> +include ../lib.mk
> >> +
> >> +khdr_dir = $(top_srcdir)/usr/include
> >> +
> >> +$(khdr_dir)/asm-generic/unistd.h: khdr
> >> +	@:
> >> +
> >> +$(khdr_dir)/linux/trusted-for.h: khdr
> >> +	@:
> >> +
> >> +$(OUTPUT)/%_test: %_test.c $(khdr_dir)/asm-generic/unistd.h $(khdr_dir)/linux/trusted-for.h ../kselftest_harness.h
> >> +	$(LINK.c) $< $(LDLIBS) -o $@ -I$(khdr_dir)
> > 
> > Is all this really needed?
> 
> Yes, all this is needed to be sure that the tests will be rebuild when a
> dependency change (either one of the header files or a source file).
> 
> > 
> > - CFLAGS and LDLIBS will be used by the default rules
> 
> Yes, but it will only run the build command when a source file change,
> not a header file.
> 
> > - khdr is already a pre-dependency when KSFT_KHDR_INSTALL is set
> 
> Yes, but it is not enough to rebuild the tests (and check the installed
> files) when a header file change.
> 
> > - kselftest_harness.h is already a build-dep (see LOCAL_HDRS)
> 
> Yes, but without an explicit requirement, changing kselftest_harness.h
> doesn't force a rebuild.
> 
> > - TEST_GEN_PROGS's .c files are already build-deps
> 
> It is not enough to trigger test rebuilds.
> 
> > 
> > kselftest does, oddly, lack a common -I when KSFT_KHDR_INSTALL is set
> > (which likely should get fixed, though separately from here).
> > 
> > I think you just want:
> > 
> > 
> > src_test := $(wildcard *_test.c)
> > TEST_GEN_PROGS := $(src_test:.c=)
> > 
> > KSFT_KHDR_INSTALL := 1
> > include ../lib.mk
> > 
> > CFLAGS += -Wall -O2 -I$(BUILD)/usr/include
> > LDLIBS += -lcap
> > 
> > $(OUTPUT)/%_test: $(BUILD)/usr/include/linux/trusted-for.h
> > 
> > 
> > (untested)
> > 
> Yep, I re-checked and my Makefile is correct. I didn't find a way to
> make it lighter while correctly handling dependencies.
> I'll just move the -I to CFLAGS.

Okay, thanks for double-checking these. I'll try to fix up kselftests to
DTRT here.

-- 
Kees Cook

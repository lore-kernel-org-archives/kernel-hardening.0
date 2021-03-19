Return-Path: <SRS0=7NW2=IR=lists.openwall.com=kernel-hardening-return-21002-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3C6C433DB
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:12:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AE39161941
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE39161941
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21002-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8178 invoked by uid 550); 19 Mar 2021 19:11:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8152 invoked from network); 19 Mar 2021 19:11:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8+dj9XdsQigirosGIEMIHcITvWVWyXmBGTduGwQLkwQ=;
        b=SMFAohEOg1b0SvUCrqANnZ14nWX3kYufAeHLUH1T4fip5oY60hqPpZPYYdIwxuM5Go
         +6zNXws6SgckWc+bIn46xfilkhShdmMK8VAZSDFVmdPEMJYX5aVVTSfR5JljwADmLJTu
         fa4+TfL/+RgVxnoewR/Gnyf24K/AHGmZxK9sI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8+dj9XdsQigirosGIEMIHcITvWVWyXmBGTduGwQLkwQ=;
        b=Kj1XUVZnrKEleupgEsSbzROVTCrNFnmnzqZp2BSleaP51i/6KvpobeiVukYYEo61JL
         0Pko4dbvDu+KBFqkRiUnx2AL0ndz7Ddg4tV/aWI8Eiy/q28KYPbFGPQOoOArqusSiHcU
         M6eUYbJY0p+2sxuHh/NUfOosvfexmRs4lEjnso68mldhLBP8649/weWEIBkaBIABU822
         nWgFTwpnGj1gbl1T4AsbXD2f/2bMbJOj/KzGmG7Gwu9Ca/qlVPSDf5Sw7fYPC31bNDhl
         xx4azMbl7oWVacap5ioodiC5EvdCgAu/o4VUvq0AUSRFom/I36X4meXAzEYF/sR0t0Tl
         z0kA==
X-Gm-Message-State: AOAM533L42XPjvDzEH+AyG2RO60TaJYnGtoBdxiTk2bk2Aag4BoCzGRS
	YEUmjmANAG5nlbQGCpjeG6kPhQ==
X-Google-Smtp-Source: ABdhPJw77NJBXyie+CZaWQgxVAqktzOswabCGYKmJ35fViYrJhan5H46f0mY2WOpg1a64hwApsbuNg==
X-Received: by 2002:a17:90a:c207:: with SMTP id e7mr11982pjt.188.1616181101020;
        Fri, 19 Mar 2021 12:11:41 -0700 (PDT)
Date: Fri, 19 Mar 2021 12:11:39 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v30 10/12] selftests/landlock: Add user space tests
Message-ID: <202103191207.E12FD4E51@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-11-mic@digikod.net>
 <202103191026.D936362B@keescook>
 <e98a1f48-4c35-139d-af88-b6e65fbb5c3f@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e98a1f48-4c35-139d-af88-b6e65fbb5c3f@digikod.net>

On Fri, Mar 19, 2021 at 07:41:00PM +0100, Mickaël Salaün wrote:
> 
> On 19/03/2021 18:56, Kees Cook wrote:
> > On Tue, Mar 16, 2021 at 09:42:50PM +0100, Mickaël Salaün wrote:
> >> From: Mickaël Salaün <mic@linux.microsoft.com>
> >>
> >> Test all Landlock system calls, ptrace hooks semantic and filesystem
> >> access-control with multiple layouts.
> >>
> >> Test coverage for security/landlock/ is 93.6% of lines.  The code not
> >> covered only deals with internal kernel errors (e.g. memory allocation)
> >> and race conditions.
> >>
> >> Cc: James Morris <jmorris@namei.org>
> >> Cc: Jann Horn <jannh@google.com>
> >> Cc: Kees Cook <keescook@chromium.org>
> >> Cc: Serge E. Hallyn <serge@hallyn.com>
> >> Cc: Shuah Khan <shuah@kernel.org>
> >> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> >> Reviewed-by: Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>
> >> Link: https://lore.kernel.org/r/20210316204252.427806-11-mic@digikod.net
> > 
> > This is terrific. I love the coverage. How did you measure this, BTW?
> 
> I used gcov: https://www.kernel.org/doc/html/latest/dev-tools/gcov.html
> 
> > To increase it into memory allocation failures, have you tried
> > allocation fault injection:
> > https://www.kernel.org/doc/html/latest/fault-injection/fault-injection.html
> 
> Yes, it is used by syzkaller, but I don't know how to extract this
> specific coverage.
> 
> > 
> >> [...]
> >> +TEST(inconsistent_attr) {
> >> +	const long page_size = sysconf(_SC_PAGESIZE);
> >> +	char *const buf = malloc(page_size + 1);
> >> +	struct landlock_ruleset_attr *const ruleset_attr = (void *)buf;
> >> +
> >> +	ASSERT_NE(NULL, buf);
> >> +
> >> +	/* Checks copy_from_user(). */
> >> +	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 0, 0));
> >> +	/* The size if less than sizeof(struct landlock_attr_enforce). */
> >> +	ASSERT_EQ(EINVAL, errno);
> >> +	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 1, 0));
> >> +	ASSERT_EQ(EINVAL, errno);
> > 
> > Almost everywhere you're using ASSERT instead of EXPECT. Is this correct
> > (in the sense than as soon as an ASSERT fails the rest of the test is
> > skipped)? I do see you using EXPECT is some places, but I figured I'd
> > ask about the intention here.
> 
> I intentionally use ASSERT as much as possible, but I use EXPECT when an
> error could block a test or when it could stop a cleanup (i.e. teardown).

Okay. Does the test suite run sanely when landlock is missing from the
kernel?

> > 
> >> +/*
> >> + * TEST_F_FORK() is useful when a test drop privileges but the corresponding
> >> + * FIXTURE_TEARDOWN() requires them (e.g. to remove files from a directory
> >> + * where write actions are denied).  For convenience, FIXTURE_TEARDOWN() is
> >> + * also called when the test failed, but not when FIXTURE_SETUP() failed.  For
> >> + * this to be possible, we must not call abort() but instead exit smoothly
> >> + * (hence the step print).
> >> + */
> > 
> > Hm, interesting. I think this should be extracted into a separate patch
> > and added to the test harness proper.
> 
> I agree, but it may require some modifications to fit nicely in
> kselftest_harness.h . For now, it works well for my use case. I'll send
> patches once Landlock is merged. In fact, I already made
> kselftest_harness.h available for other users than seccomp. ;)

Fair points.

> > 
> > Could this be solved with TEARDOWN being called on SETUP failure?
> 
> The goal of this helper is to still be able to call TEARDOWN when TEST
> failed, not SETUP.
> 
> > 
> >> +#define TEST_F_FORK(fixture_name, test_name) \
> >> +	static void fixture_name##_##test_name##_child( \
> >> +		struct __test_metadata *_metadata, \
> >> +		FIXTURE_DATA(fixture_name) *self, \
> >> +		const FIXTURE_VARIANT(fixture_name) *variant); \
> >> +	TEST_F(fixture_name, test_name) \
> >> +	{ \
> >> +		int status; \
> >> +		const pid_t child = fork(); \
> >> +		if (child < 0) \
> >> +			abort(); \
> >> +		if (child == 0) { \
> >> +			_metadata->no_print = 1; \
> >> +			fixture_name##_##test_name##_child(_metadata, self, variant); \
> >> +			if (_metadata->skip) \
> >> +				_exit(255); \
> >> +			if (_metadata->passed) \
> >> +				_exit(0); \
> >> +			_exit(_metadata->step); \
> >> +		} \
> >> +		if (child != waitpid(child, &status, 0)) \
> >> +			abort(); \
> >> +		if (WIFSIGNALED(status) || !WIFEXITED(status)) { \
> >> +			_metadata->passed = 0; \
> >> +			_metadata->step = 1; \
> >> +			return; \
> >> +		} \
> >> +		switch (WEXITSTATUS(status)) { \
> >> +		case 0: \
> >> +			_metadata->passed = 1; \
> >> +			break; \
> >> +		case 255: \
> >> +			_metadata->passed = 1; \
> >> +			_metadata->skip = 1; \
> >> +			break; \
> >> +		default: \
> >> +			_metadata->passed = 0; \
> >> +			_metadata->step = WEXITSTATUS(status); \
> >> +			break; \
> >> +		} \
> >> +	} \
> > 
> > This looks like a subset of __wait_for_test()? Could __TEST_F_IMPL() be
> > updated instead to do this? (Though the fork overhead might not be great
> > for everyone.)
> 
> Yes, it will probably be my approach to update kselftest_harness.h .

It seems like this would be named better as TEST_DROPS_PRIVS or something,
which describes the reason for the fork.

-- 
Kees Cook

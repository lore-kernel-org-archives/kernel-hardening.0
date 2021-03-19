Return-Path: <SRS0=q+3J=IR=lists.openwall.com=kernel-hardening-return-20989-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E667EC433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 17:57:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B5DA66197E
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 17:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5DA66197E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20989-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21814 invoked by uid 550); 19 Mar 2021 17:56:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21707 invoked from network); 19 Mar 2021 17:56:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+q/3pbtU4KRBeCiClf1jVde3rqJff5tAE3G/yUO/twY=;
        b=Px46bBJ7mvrljx8ek9g5SOvd1jKb2iflgcqeVZiVe5xUV+ssBoFXrkhepVOQKvAu0W
         wc544ZAyTrYKxp4eU7wneG31VhgV2pG4OO8vR/OUGy+eT4tlva1ClajEyl5BGBpqNmzG
         hunNRfv4R9KjhPsKcrcyZbynh9VC1EqLCPhJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+q/3pbtU4KRBeCiClf1jVde3rqJff5tAE3G/yUO/twY=;
        b=lxMocZezSgACC39HmC7xCLB0WyyXVHoLzxXL/yW5P8Ljnn0pfjsH621AZJY+hyjRF3
         nQl0eBeND07ERAG+uxGwTzYFnHFs+nScQ/R53F5c97bK4cudXcFoU2+jx70hhoJEGdR6
         Vh4WC18RbuPpeVCX2y5Hi9cvqsTxUJ5i0xfYiGzmtVnskzxwFkrVpBg8WObyXZnIT1nA
         ZX3JHWvLzLn1jNJo9UBgkMLGJysCSPzhuYF0pO7dd68Q42iSwS4iXvkKOwX5op0W8wJB
         rivmcmPfDO5KCfrkqjQIZBzxXMJeDMpIBTK7LaJBH7gMII2GgPGiv3aKCyogG8uUTDfD
         dR4g==
X-Gm-Message-State: AOAM530kvM1p5ssHrHNHN52BIBArED4koKfaYoEr8WYX61a19eGRrOjo
	nJU2X1JwzXQ7Tdi/ecJP3S8tAA==
X-Google-Smtp-Source: ABdhPJx6hzgtsuXfb3wb8ZxJRkArVpobtGIGuejpGbWx0f2z95FZcMrh5SMDfiqjnPliwFHzGPG83w==
X-Received: by 2002:aa7:8493:0:b029:1ee:75b2:2865 with SMTP id u19-20020aa784930000b02901ee75b22865mr10002946pfn.61.1616176594196;
        Fri, 19 Mar 2021 10:56:34 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:56:32 -0700
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
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 10/12] selftests/landlock: Add user space tests
Message-ID: <202103191026.D936362B@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-11-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-11-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:50PM +0100, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Test all Landlock system calls, ptrace hooks semantic and filesystem
> access-control with multiple layouts.
> 
> Test coverage for security/landlock/ is 93.6% of lines.  The code not
> covered only deals with internal kernel errors (e.g. memory allocation)
> and race conditions.
> 
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> Reviewed-by: Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>
> Link: https://lore.kernel.org/r/20210316204252.427806-11-mic@digikod.net

This is terrific. I love the coverage. How did you measure this, BTW?
To increase it into memory allocation failures, have you tried
allocation fault injection:
https://www.kernel.org/doc/html/latest/fault-injection/fault-injection.html

> [...]
> +TEST(inconsistent_attr) {
> +	const long page_size = sysconf(_SC_PAGESIZE);
> +	char *const buf = malloc(page_size + 1);
> +	struct landlock_ruleset_attr *const ruleset_attr = (void *)buf;
> +
> +	ASSERT_NE(NULL, buf);
> +
> +	/* Checks copy_from_user(). */
> +	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 0, 0));
> +	/* The size if less than sizeof(struct landlock_attr_enforce). */
> +	ASSERT_EQ(EINVAL, errno);
> +	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 1, 0));
> +	ASSERT_EQ(EINVAL, errno);

Almost everywhere you're using ASSERT instead of EXPECT. Is this correct
(in the sense than as soon as an ASSERT fails the rest of the test is
skipped)? I do see you using EXPECT is some places, but I figured I'd
ask about the intention here.

> +/*
> + * TEST_F_FORK() is useful when a test drop privileges but the corresponding
> + * FIXTURE_TEARDOWN() requires them (e.g. to remove files from a directory
> + * where write actions are denied).  For convenience, FIXTURE_TEARDOWN() is
> + * also called when the test failed, but not when FIXTURE_SETUP() failed.  For
> + * this to be possible, we must not call abort() but instead exit smoothly
> + * (hence the step print).
> + */

Hm, interesting. I think this should be extracted into a separate patch
and added to the test harness proper.

Could this be solved with TEARDOWN being called on SETUP failure?

> +#define TEST_F_FORK(fixture_name, test_name) \
> +	static void fixture_name##_##test_name##_child( \
> +		struct __test_metadata *_metadata, \
> +		FIXTURE_DATA(fixture_name) *self, \
> +		const FIXTURE_VARIANT(fixture_name) *variant); \
> +	TEST_F(fixture_name, test_name) \
> +	{ \
> +		int status; \
> +		const pid_t child = fork(); \
> +		if (child < 0) \
> +			abort(); \
> +		if (child == 0) { \
> +			_metadata->no_print = 1; \
> +			fixture_name##_##test_name##_child(_metadata, self, variant); \
> +			if (_metadata->skip) \
> +				_exit(255); \
> +			if (_metadata->passed) \
> +				_exit(0); \
> +			_exit(_metadata->step); \
> +		} \
> +		if (child != waitpid(child, &status, 0)) \
> +			abort(); \
> +		if (WIFSIGNALED(status) || !WIFEXITED(status)) { \
> +			_metadata->passed = 0; \
> +			_metadata->step = 1; \
> +			return; \
> +		} \
> +		switch (WEXITSTATUS(status)) { \
> +		case 0: \
> +			_metadata->passed = 1; \
> +			break; \
> +		case 255: \
> +			_metadata->passed = 1; \
> +			_metadata->skip = 1; \
> +			break; \
> +		default: \
> +			_metadata->passed = 0; \
> +			_metadata->step = WEXITSTATUS(status); \
> +			break; \
> +		} \
> +	} \

This looks like a subset of __wait_for_test()? Could __TEST_F_IMPL() be
updated instead to do this? (Though the fork overhead might not be great
for everyone.)

-- 
Kees Cook

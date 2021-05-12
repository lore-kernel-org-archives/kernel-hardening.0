Return-Path: <SRS0=jnIT=KH=lists.openwall.com=kernel-hardening-return-21261-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7C6C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 May 2021 13:17:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB8466112D
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 May 2021 13:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB8466112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21261-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18094 invoked by uid 550); 12 May 2021 13:17:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16376 invoked from network); 12 May 2021 13:14:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1620825261;
	bh=MJT/LqqGBgI+Qn4TX3THbJYSnAwXa3ctfwqTmXh1reg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UOmD3ZxcOUqVM6Qh81PohBXMD2GwlN7cRxBO6/ZUIhPc3Fl0ks1OvlQNQdkZXo+RL
	 CKkrUlSvnvrJtwQ3J2eMOaYGMjOTceNVCsUeY6pixpm7AxEdj7KUQrvLR92A1mLM7W
	 2lM/TyJwPfs6/vKDAu86qdbWypFZW3l+KIYFDQxyifeibp1hJNI4q9V6fbUN0SwO/6
	 CFvxaLuXoIvI+pvIrt5wIPPGIqMUK7AceSfDPEe1+vy2O2+RDNUpnUTAMKx1sCRumT
	 MofyKMbjGLcWimP2y6fpJMGr3bSMnBaajsiEVniwOfz6zhaMfaj322qfPaszqCVW6U
	 2gkHPjt7HBbRw==
Date: Wed, 12 May 2021 15:14:16 +0200
From: Alexey Gladkov <legion@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v11 0/9] Count rlimits in each user namespace
Message-ID: <20210512131416.ari5cjzhs754tknd@example.org>
References: <cover.1619094428.git.legion@kernel.org>
 <20210509181205.f0ce806919858efa0e0e0d20@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210509181205.f0ce806919858efa0e0e0d20@linux-foundation.org>

On Sun, May 09, 2021 at 06:12:05PM -0700, Andrew Morton wrote:
> On Thu, 22 Apr 2021 14:27:07 +0200 legion@kernel.org wrote:
> 
> > These patches are for binding the rlimit counters to a user in user namespace.
> 
> It's at v11 and no there has been no acking or reviewing activity?  Or
> have you not been tracking these?

Eric W. Biederman told me he's ready to pick it [1]. But as far as I can
see he hasn't put it in for-next yet.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git/log/?h=ucounts-rlimits-for-v5.13

-- 
Rgrds, legion


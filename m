Return-Path: <SRS0=FZ2B=A3=lists.openwall.com=kernel-hardening-return-19358-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A55DC433E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:13:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B56F72065F
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eUF5kUcP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B56F72065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19358-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1129 invoked by uid 550); 16 Jul 2020 19:13:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1107 invoked from network); 16 Jul 2020 19:13:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=P2Y3x3UF7aakg+eDh/JCMQ/ujg3OM7agEmMMQHUiWYw=;
        b=eUF5kUcP1I8IOHUVxI3FxJ/qxspiNpwWZ1kyR1myyi5d/rlntny124yFpRoBP0S+TU
         IULeT+p9QcpLBQJdqAMtaWb0tPOnG564tv2NICoimzwkKBF7b7R+TO++MSXHI9kPTYW4
         dLCo8Qo5IB3QU1NMvjyOcqhje5qnF9Vt8u7nM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=P2Y3x3UF7aakg+eDh/JCMQ/ujg3OM7agEmMMQHUiWYw=;
        b=KV+o6gKR4W2gp//cRjY0sCIT2h0Cxzu3nK+TD6p/8JYE9CSVU8gPs3EKlrHB73AAYV
         ZK1uBZuzCn5/qFq7pYrsvQg4wwveVNhfRKgwvmkeX1Aq5+FCV1vrEoi2kUpm/1T5qYgu
         19LQCEqCe3at9rE18cQG8JUCO6cXuU6CwByvhN95H8EQ26NHRIDOTBe34y4xQsKXBmM/
         ZhuHI1aLDT+VPwaTnpPeov2zabE5TsYSc9IiILTOdW/JgKNChjHuPHf61EBCSZYqsSrX
         9mstGnbWUuqpYiVSY2HmXcizRcOFOQDE08fd+aBb5rEniOS4OZrs+1n/sfUnsv8GD3uh
         At6A==
X-Gm-Message-State: AOAM53192JWeZcrBnM79ou7civyLQnIbkqak9OCyFWvh3Fw3GyghVzJQ
	yAJBlhf8udfGaJMAGkSLRNOTiQ==
X-Google-Smtp-Source: ABdhPJy1fQTquN4l33pCs4D4d2Xd1YwY/TqBCMAGvi2rtEVPLt90LIg/bGHmjLscqWmRjzI4Zwih4g==
X-Received: by 2002:a63:c150:: with SMTP id p16mr5583761pgi.141.1594926811598;
        Thu, 16 Jul 2020 12:13:31 -0700 (PDT)
Date: Thu, 16 Jul 2020 12:13:29 -0700
From: Kees Cook <keescook@chromium.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] ima: add policy support for the new file open
 MAY_OPENEXEC flag
Message-ID: <202007161213.E8D240D98@keescook>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-8-mic@digikod.net>
 <202007151339.283D7CD@keescook>
 <8df69733-0088-3e3c-9c3d-2610414cea2b@digikod.net>
 <61c05cb0-a956-3cc7-5dab-e11ebf0e95bf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61c05cb0-a956-3cc7-5dab-e11ebf0e95bf@infradead.org>

On Thu, Jul 16, 2020 at 07:59:20AM -0700, Randy Dunlap wrote:
> On 7/16/20 7:40 AM, Mickaël Salaün wrote:
> > 
> > On 15/07/2020 22:40, Kees Cook wrote:
> >> On Tue, Jul 14, 2020 at 08:16:38PM +0200, Mickaël Salaün wrote:
> >>> From: Mimi Zohar <zohar@linux.ibm.com>
> >>>
> >>> The kernel has no way of differentiating between a file containing data
> >>> or code being opened by an interpreter.  The proposed O_MAYEXEC
> >>> openat2(2) flag bridges this gap by defining and enabling the
> >>> MAY_OPENEXEC flag.
> >>>
> >>> This patch adds IMA policy support for the new MAY_OPENEXEC flag.
> >>>
> >>> Example:
> >>> measure func=FILE_CHECK mask=^MAY_OPENEXEC
> >>> appraise func=FILE_CHECK appraise_type=imasig mask=^MAY_OPENEXEC
> >>>
> >>> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> >>> Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> >>> Acked-by: Mickaël Salaün <mic@digikod.net>
> >>
> >> (Process nit: if you're sending this on behalf of another author, then
> >> this should be Signed-off-by rather than Acked-by.)
> > 
> > I'm not a co-author of this patch.
> > 
> 
> from Documentation/process/submitting-patches.rst:
> 
> The Signed-off-by: tag indicates that the signer was involved in the
> development of the patch, or that he/she was in the patch's delivery path.
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Randy beat me to it. :)

-- 
Kees Cook

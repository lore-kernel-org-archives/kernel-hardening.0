Return-Path: <SRS0=Ua01=A3=lists.openwall.com=kernel-hardening-return-19357-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725E3C433E8
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:13:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BFAB12065F
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 19:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lhX4KRZz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFAB12065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19357-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32051 invoked by uid 550); 16 Jul 2020 19:13:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32024 invoked from network); 16 Jul 2020 19:13:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=reZvnOQ8bijPp6S5yQzmCOTTsMLuDmnyX5N/3GfwHXo=;
        b=lhX4KRZzVkUSda9R6NyorS54yyDn6hPMA24J3zBk96aHpX1ic/PoqYAe/VIB7Xy9B/
         HlVJ28tVKHEHHcNCuv/KrJOZBUcoLwz6roC1HJNW31P8tAYmIPcACI0nrMG4j1+ivpMt
         1Xfyw0pkzrtmnsj0jd8RERq8Fj7NvEgD8QxLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=reZvnOQ8bijPp6S5yQzmCOTTsMLuDmnyX5N/3GfwHXo=;
        b=ZSnoyuv6KU+RHu58t5wyLGBqhkC+2gDmPjHFfLLFUOk48xtLoN7f8K+Frlskdc25FG
         NnRNOOwslZFa98hWZISuivMavV1MDx0YExCC4juvKwFdCJ4LFbsHpSmwKGWcbyQw/Fbx
         Zgoko0e6RF/zv4OZWqIeVmhJprzx7rLkLUhQ7312zsI8ATzBzdwqsLBsok3O4lIJjAgh
         NmzQqoBr/Z07D8RrCxIKBtZdNFkhk35diTZBo7ppxemyYt6tuaGAjWKtTeCIpP9vtVWw
         GUuwNoDTc2QFYYkxtDISi2gIxBVKd6JBPInczM35bKuJpkbd8z/I/kboCOlpzOGHsCMW
         DbVQ==
X-Gm-Message-State: AOAM531hvPMTYstURRN4s5YbXAsPCsBpFAfxurigjnlmlkfeZn6wI/Hb
	vbkBhxv/u+hF+pLy1ROrmMlrwQ==
X-Google-Smtp-Source: ABdhPJzSOAMegB1OmeJ/PboDzHabSRQP9lhAlD8QVD09gpvRf9fpyvnr8fMJH6cpEeTI0kWvhxJF2g==
X-Received: by 2002:a17:902:7441:: with SMTP id e1mr4615121plt.23.1594926769952;
        Thu, 16 Jul 2020 12:12:49 -0700 (PDT)
Date: Thu, 16 Jul 2020 12:12:47 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
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
Message-ID: <202007160957.CABE4CC@keescook>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-8-mic@digikod.net>
 <202007151339.283D7CD@keescook>
 <8df69733-0088-3e3c-9c3d-2610414cea2b@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8df69733-0088-3e3c-9c3d-2610414cea2b@digikod.net>

On Thu, Jul 16, 2020 at 04:40:15PM +0200, Mickaël Salaün wrote:
> 
> On 15/07/2020 22:40, Kees Cook wrote:
> > On Tue, Jul 14, 2020 at 08:16:38PM +0200, Mickaël Salaün wrote:
> >> From: Mimi Zohar <zohar@linux.ibm.com>
> >>
> >> The kernel has no way of differentiating between a file containing data
> >> or code being opened by an interpreter.  The proposed O_MAYEXEC
> >> openat2(2) flag bridges this gap by defining and enabling the
> >> MAY_OPENEXEC flag.
> >>
> >> This patch adds IMA policy support for the new MAY_OPENEXEC flag.
> >>
> >> Example:
> >> measure func=FILE_CHECK mask=^MAY_OPENEXEC
> >> appraise func=FILE_CHECK appraise_type=imasig mask=^MAY_OPENEXEC
> >>
> >> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> >> Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> >> Acked-by: Mickaël Salaün <mic@digikod.net>
> > 
> > (Process nit: if you're sending this on behalf of another author, then
> > this should be Signed-off-by rather than Acked-by.)
> 
> I'm not a co-author of this patch.

Correct, but you are part of the delivery path to its entry to the
tree. If you were co-author, you would include "Co-developed-by" with
a Signed-off-by. (So my nit stands)

For excruciating details:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

"The Signed-off-by: tag indicates that the signer was ... in the patch’s
delivery path."

"Co-developed-by: ... is a used to give attribution to co-authors ..."

-- 
Kees Cook

Return-Path: <SRS0=if3X=IR=lists.openwall.com=kernel-hardening-return-20987-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75315C433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 17:25:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6790961984
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 17:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6790961984
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20987-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20041 invoked by uid 550); 19 Mar 2021 17:25:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20017 invoked from network); 19 Mar 2021 17:25:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RPNBgVNWrZM19pIS372izv7KcqqWZ135/0V8aeAzGP4=;
        b=K1efaQIPJngSEiTSfj5NbLVfNLqZtgPvqUfvC1WNYpzdFAu7/1XTpLPBBFtmSt+oY2
         KVmLT9t34Y6/JS+Ig+PPncatAS2b/d4cD8tjJcN54O8jhVmiXiLmNkazHuqcVfqBBhC6
         yW0J2Fu5AtsfqocA+fV3xcEFAv2KViqTGmszc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RPNBgVNWrZM19pIS372izv7KcqqWZ135/0V8aeAzGP4=;
        b=R6IcYfsRB57NP7qs8Xv/WXLRcJ3+vqFPVuf2ccJC3MlO9Z54iKO926HLU5IaEBk+OL
         qezi6MNBRZeJxPXpFmSOVbQcfoHoolnx/3QVlTenfa0p4/W9WySGHUsm0QWiK09skTQB
         tXZRpoT/7AA3sMb08FH7j9s5SOSiNT6n71VDjqzFbcLGc+RmMq7AsPjxPg4SROPHKDR2
         JqjfxBMUodOFCG29VHngOsg8hV3sAVwYqPzvmiil3qM31Rxj4yJS4pyXgdkECrWwVPGS
         9Bd5LWQSenxCzhwBAzp5IVLNNw6WJ6TnW/z2FfbZ4TPXk0KmvAEUDY9+x31cwNVJsiO1
         SNIw==
X-Gm-Message-State: AOAM530oFr9CMYssBCpu6baKzCfKY1rvTz7q3O6qaFSY8KHuMUU0fGXu
	VtVR+Y8ELsaq+zT9746/uD144g==
X-Google-Smtp-Source: ABdhPJwQo7lLAkkNXduzlhCfNKIga0uRqxJV6ZyIr8rEdU6i+dH0dy8a1JUabwKCyr6ayySXYWHO+A==
X-Received: by 2002:a17:90b:291:: with SMTP id az17mr10475690pjb.206.1616174700784;
        Fri, 19 Mar 2021 10:25:00 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:24:59 -0700
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
Subject: Re: [PATCH v30 06/12] fs,security: Add sb_delete hook
Message-ID: <202103191024.436E16509C@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-7-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-7-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:46PM +0100, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> The sb_delete security hook is called when shutting down a superblock,
> which may be useful to release kernel objects tied to the superblock's
> lifetime (e.g. inodes).
> 
> This new hook is needed by Landlock to release (ephemerally) tagged
> struct inodes.  This comes from the unprivileged nature of Landlock
> described in the next commit.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: James Morris <jmorris@namei.org>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

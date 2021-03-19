Return-Path: <SRS0=BqZ+=IR=lists.openwall.com=kernel-hardening-return-20986-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8088C433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 17:24:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E73DB61983
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 17:24:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E73DB61983
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20986-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18159 invoked by uid 550); 19 Mar 2021 17:24:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18133 invoked from network); 19 Mar 2021 17:24:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=y3HPFVQQ8OcLuuAynRQtdLIpt1ZlQVl3Ddi5JOdBy0s=;
        b=ijJD/g9ZP1Yyl5fSfAFOPGlYJua+C5SS43o3CNhGgSeVXgnDiCqKQcxgzUtQ61O1a6
         H1DD1WppKq7fzQ315rtxWK9GISWoLs2ph+RpDHyd71ihbwa/fgRSHBtsctslONiHt+uZ
         IeDn5qP5KUNNOs2PjSdqbqFrlcXgz6WS/Gnp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=y3HPFVQQ8OcLuuAynRQtdLIpt1ZlQVl3Ddi5JOdBy0s=;
        b=QxBFIAEtQ94J05yO1N8arBT1ap94i6+WpzQCAFPvcabnUZrYZfss8BbDx/M3LmlXgh
         1Hwz40/gO5XcQ9GImLa3ABkG3DKgpv+xfbgRXlyg17e9y1tu4efUgh8opNthSblZk+fg
         O0UqNY/gn8uXksLd/pdWv42mBY+WnBQTFbFjiIUsrrKMmNyMZq2OtCEHPDfzIQOBc16H
         EFzL6pE1CpKnAs2nPpGqXTEDLiDS1cOsblPLSmRs0urasPeVZDfw8/AAkywDmm+ddFmH
         QvwBPxJG8wj0B0bA4MBLYoB/aFVtHLT2J4svFepokPm62IOnE3UDuaKPhYEmZgK45zcA
         Rafg==
X-Gm-Message-State: AOAM532Cz2cKNlR12dJVUvQ9rGdOr+GFKG4FE203id/NB+JjrxM7kn1L
	dWEWGeovhvErmEGtc4xiHXs3gw==
X-Google-Smtp-Source: ABdhPJxof2S7NAyn0wwLIRht63qQ8yxLGkdNHCaohi74HUCi/0cELJkStbwnSdwtemmhQBNrzgFv4w==
X-Received: by 2002:a65:4887:: with SMTP id n7mr12266351pgs.14.1616174671959;
        Fri, 19 Mar 2021 10:24:31 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:24:30 -0700
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
	John Johansen <john.johansen@canonical.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>
Subject: Re: [PATCH v30 05/12] LSM: Infrastructure management of the
 superblock
Message-ID: <202103191024.40EBCA2C@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-6-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-6-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:45PM +0100, Mickaël Salaün wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Move management of the superblock->sb_security blob out of the
> individual security modules and into the security infrastructure.
> Instead of allocating the blobs from within the modules, the modules
> tell the infrastructure how much space is required, and the space is
> allocated there.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: John Johansen <john.johansen@canonical.com>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

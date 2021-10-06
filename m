Return-Path: <SRS0=cU4h=O2=lists.openwall.com=kernel-hardening-return-21416-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73BDC433F5
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Oct 2021 22:03:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CCC9A610A1
	for <kernel-hardening@archiver.kernel.org>; Wed,  6 Oct 2021 22:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CCC9A610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 5121 invoked by uid 550); 6 Oct 2021 22:03:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4074 invoked from network); 6 Oct 2021 22:03:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=S8r+rc6bFIU7cXArQnf6Qtpwv2FoCGPsccPj2q+K1zk=;
        b=BlcpB5NSeXXefPepERXjr0jUHlucP3qusHB3fY//2ntWT4PaA2nle9ET0X3AI1HmEH
         feGtjzF6zI0ZgP3SazGlzI7XQsy/joCst2lDK+wX83vnR+9++PDS05+ZQtLJy+cp0Zww
         49ZwkdVQHaEFSC8vTVzcnAqC2r7EwFKG1KnMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S8r+rc6bFIU7cXArQnf6Qtpwv2FoCGPsccPj2q+K1zk=;
        b=kQhgI65bEoPoEQT2/AOJOc6Rr5v3HpwL0m/LB7dSXSFq3ALo4Wf4up8nmfCeeFRz2d
         43xZ3XEBr//QwPanW65xmCv2NJYeZlC2evYHfYPT8VjByilTu9197ErBM56QQB88O/SK
         6A/nCJCXOkI41XbWQ7BBmmS+/aO9VvegxX6qlDmZTJoHDsUhO3ekohYoMC5PC/mnqGf3
         7ueD2hF0w961/V6UZElYhkk8ZzUOAOkYL/jR5RqFcTVa2RML+rOFV2P8e7jOlzhLUCoN
         TaDoLRLYK/HdFNqiqB4HvZF0Ch7+m20S0S3lifNActPRI9ONy3fF1B9YvLmMOzdFiWo1
         NU0w==
X-Gm-Message-State: AOAM5309HOSN0SIXkarlfaVjRz2Gnvqf3GMkL8cwj4dbnbVpXWaDSA5v
	WUPGF/dM5ZkkXYh/0Raef+r6dg==
X-Google-Smtp-Source: ABdhPJzouFSoNpCm18n4Iwn3EUMcJjerfXPUN9YpUneFa6F70rdyCB8CBylaxKHlD/YEVHoOYPZFMQ==
X-Received: by 2002:a63:e651:: with SMTP id p17mr420929pgj.66.1633557801181;
        Wed, 06 Oct 2021 15:03:21 -0700 (PDT)
Date: Wed, 6 Oct 2021 15:03:19 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: bauen1 <j2468h@googlemail.com>, akpm@linux-foundation.org,
	arnd@arndb.de, casey@schaufler-ca.com, christian.brauner@ubuntu.com,
	christian@python.org, corbet@lwn.net, cyphar@cyphar.com,
	deven.desai@linux.microsoft.com, dvyukov@google.com,
	ebiggers@kernel.org, ericchiang@google.com, fweimer@redhat.com,
	geert@linux-m68k.org, jack@suse.cz, jannh@google.com,
	jmorris@namei.org, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, luto@kernel.org,
	madvenka@linux.microsoft.com, mjg59@google.com, mszeredi@redhat.com,
	mtk.manpages@gmail.com, nramas@linux.microsoft.com,
	philippe.trebuchet@ssi.gouv.fr, scottsh@microsoft.com,
	sean.j.christopherson@intel.com, sgrubb@redhat.com,
	shuah@kernel.org, steve.dower@python.org,
	thibaut.sautereau@clip-os.org, vincent.strubel@ssi.gouv.fr,
	viro@zeniv.linux.org.uk, willy@infradead.org, zohar@linux.ibm.com
Subject: Re: [PATCH v12 0/3] Add trusted_for(2) (was O_MAYEXEC)
Message-ID: <202110061500.B8F821C@keescook>
References: <20201203173118.379271-1-mic@digikod.net>
 <d3b0da18-d0f6-3f72-d3ab-6cf19acae6eb@gmail.com>
 <2a4cf50c-7e79-75d1-7907-8218e669f7fa@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a4cf50c-7e79-75d1-7907-8218e669f7fa@digikod.net>

On Fri, Apr 09, 2021 at 07:15:42PM +0200, Mickaël Salaün wrote:
> There was no new reviews, probably because the FS maintainers were busy,
> and I was focused on Landlock (which is now in -next), but I plan to
> send a new patch series for trusted_for(2) soon.

Hi!

Did this ever happen? It looks like it's in good shape, and I think it's
a nice building block for userspace to have. Are you able to rebase and
re-send this?

I've tended to aim these things at akpm if Al gets busy. (And since
you've had past review from Al, that should be hopefully sufficient.)

Thanks for chasing this!

-Kees

-- 
Kees Cook

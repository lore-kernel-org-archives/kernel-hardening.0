Return-Path: <kernel-hardening-return-21703-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 53E49CD6E7E
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Oct 2023 15:50:18 +0000 (UTC)
Received: (qmail 32501 invoked by uid 550); 11 Oct 2023 15:50:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32457 invoked from network); 11 Oct 2023 15:50:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697039394; x=1697644194; darn=lists.openwall.com;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tt8MwjCSYr74Or48iYM/l/RqNnasbGQn1+JY5bpViwY=;
        b=Lr8h/8DfxBDOqwxuOKi8S7i0T/6kIhwkmZqrKCB/ImN6BtHEabDxEuXW+e2HG0ZlYG
         TX/B64vFBTvI7KD7WddtqTgk4C/lezm1TW1ABLCKAwQ8wzOW5hnkXxjB45aCobM3acQ6
         B2JV5g/bPIjVKi1F+M3aHtXMV199zli3omlB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697039394; x=1697644194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tt8MwjCSYr74Or48iYM/l/RqNnasbGQn1+JY5bpViwY=;
        b=lu0IX2l693+Pik2lc/dwfCdInAYPhNz0ONMrtyEV2m4QCDpziSpA9fIcw4PysFsFCw
         0t3wMHoPFfc0knfIf9edy4dBB1J8Ihv6VhpUf5tlKIrvqbdaHGOGTDQDH4sSKer4qV2D
         A9f97//Zlsz3onKjQ6EUG3uqTPwqL0QJ1RauumT0wPtvQBvdogBJoqi7nWkfgDZvsJTa
         yyi7JLdzXlDUvwDwde7KCvrZL89oe3Bti8LKlVhczCMx2jutSwYL2/rUXcQ2/b0v/kpJ
         5a207+Mp/MtmdoIu1Q9kjYp8vX1ZSssn/cEsIb7yHVSHA+twt5ES7zD8HW9OF2exbPDG
         TMug==
X-Gm-Message-State: AOJu0YyCRnbuOrgZ7fIhDnmkbF/W2H83G23ZRvxeR6lcvBLpMMP5q1nB
	bXY6wwwtAFrH/CIjkEWiRJI/AA==
X-Google-Smtp-Source: AGHT+IGoql2BOZW/W94u3YHjsRu7KtNzNIs8R3v+AEXpI8EmWBmEOIJfDUTYbIgJ3eZ64AGhslXtHw==
X-Received: by 2002:a17:903:187:b0:1bc:2d43:c747 with SMTP id z7-20020a170903018700b001bc2d43c747mr28217831plg.38.1697039394124;
        Wed, 11 Oct 2023 08:49:54 -0700 (PDT)
Date: Wed, 11 Oct 2023 08:49:51 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>,
	kernel-hardening@lists.openwall.com,
	Jiri Slaby <jirislaby@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Moore <paul@paul-moore.com>,
	David Laight <David.Laight@aculab.com>,
	Simon Brand <simon.brand@postadigitale.de>,
	Dave Mielke <Dave@mielke.cc>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	KP Singh <kpsingh@google.com>,
	Nico Schottelius <nico-gpm2008@schottelius.org>
Subject: sending commit notification to patch thread (was "Re: [PATCH v3 0/1]
 Restrict access to TIOCLINUX")
Message-ID: <202310110847.1BDD74DB@keescook>
References: <20230828164117.3608812-1-gnoack@google.com>
 <20230828164521.tpvubdufa62g7zwc@begin>
 <ZO3r42zKRrypg/eM@google.com>
 <ZQRc7e0l2SjsCB5m@google.com>
 <202310091319.F1D49BC30B@keescook>
 <2023101045-stride-auction-1b9e@gregkh>
 <202310101522.A4446CF1D@keescook>
 <2023101158-esteemed-condiment-1dd6@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023101158-esteemed-condiment-1dd6@gregkh>

On Wed, Oct 11, 2023 at 08:22:49AM +0200, Greg KH wrote:
> What b4 option does a "I applied this patch" response?  The
> --cc-trailers option to 'shazam'?  Or something else?

If you're using "b4 shazam", then it'll keep a record of it already and
you can use "b4 ty" to send the "thank you" email to the thread.

-- 
Kees Cook

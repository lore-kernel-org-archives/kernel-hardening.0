Return-Path: <kernel-hardening-return-21513-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id B377EC433F5
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Dec 2021 16:40:40 +0000 (UTC)
Received: (qmail 10109 invoked by uid 550); 1 Dec 2021 16:40:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10086 invoked from network); 1 Dec 2021 16:40:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=y8cmWY4Zar66oxROb9aCaWg+WHCdO5TorclDxazoih0=;
        b=KMrgAdmxIQ8K3dFwdZP0KgMke/VWmOiwmkpwK8XtO5jg0bv+IwT6kwy5QeCS8cVmkG
         iXva0YNAfh0jDs3F2vVeVDeeSEVNtLaDMU2jGFO9dRGbP5aXdL3iPH4S0TdEOsAPotsb
         vAd3VHhwy3mFo4QwZrOfawXcT16vzNk/wWXh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=y8cmWY4Zar66oxROb9aCaWg+WHCdO5TorclDxazoih0=;
        b=EHZHI50NzbmZV6dZo8pQ0a6VDVIX8uujGBEiocPD7HSLvIUTZ5P0l5QWgKHOZJoIi1
         p+Uhb/FF01bXezVnAg/uGhTbph57m+ozZa3PMUM4YQhk4CMia78OdstkPIX4nyHctPGG
         iAQTax3yMXVFTRGE5rMzJCqjDzp1I8lSAQmWrmeRFt3reMR1UkRIIT8NjbhnpJgAqG+y
         uTBx1Hf6+uciIpIKKdWhGsgV21ofR8KRyT1YjNpLok5gy53eBLjhxyP/bedsgxCQPurT
         GE1iGj0F5z9ZHA25rna6YS+kP1T1OsPtSQrNALqrYcLP98PsPQPADhYtL4Y/aZn8StYo
         gQlg==
X-Gm-Message-State: AOAM5332T+gmjhXmfvdSGYxqlvoQdocdNW6WZQFhNMYjaYEWHEQ2VrlP
	E9j24zC0y1hdUxxdS7wmG1gC1A==
X-Google-Smtp-Source: ABdhPJwJfw+rygwnhuiEpbRB+v+vZNeROz8C/SXUcdZBzJqV6OaozK2TnS2SEtEqIW0r9VUrX4HDWg==
X-Received: by 2002:a17:90b:3ec2:: with SMTP id rm2mr9031549pjb.1.1638376818926;
        Wed, 01 Dec 2021 08:40:18 -0800 (PST)
Date: Wed, 1 Dec 2021 08:40:17 -0800
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Alejandro Colomar <alx.manpages@gmail.com>,
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
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v17 0/3] Add trusted_for(2) (was O_MAYEXEC)
Message-ID: <202112010839.4362C7A70@keescook>
References: <20211115185304.198460-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211115185304.198460-1-mic@digikod.net>

On Mon, Nov 15, 2021 at 07:53:01PM +0100, Mickaël Salaün wrote:
> Andrew, can you please consider to merge this into your tree?

Friendly ping to akpm. :)

Can this start living in -mm, or would a different tree be better?

Thanks!

-Kees

-- 
Kees Cook

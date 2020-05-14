Return-Path: <SRS0=ugea=64=lists.openwall.com=kernel-hardening-return-18793-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82208C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 15:49:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CE79E20657
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 15:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PiA5t1EC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE79E20657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18793-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13424 invoked by uid 550); 14 May 2020 15:49:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13401 invoked from network); 14 May 2020 15:49:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xc0xMz/yvwFH4+2sZUX9Mzn97it6v0pR0LQRUSS/E70=;
        b=PiA5t1ECMRuuR+HXKMfA3cTte/yc0Jb2wZpjTuONoyQT8+eOxJ6lAv6xWFVheYAPQX
         mop7QRaUoUv6SEjqXRjbU5K99Kz3EUrsQLuoTiltzApmHSCKH5G+nrxw8ti9nhdb7fqe
         jWfLI5KiJD47MHevRL9KAaQDdLmDrDUpw7Tiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xc0xMz/yvwFH4+2sZUX9Mzn97it6v0pR0LQRUSS/E70=;
        b=UTqSrq7FNBSSR0kSHpy53ZzP4DSlzntPALsaEUc5mSl31Kur5JpYZL8Nerg7BVFF/m
         VgmbbvyFMRPNwaYJ1P/343xjn2zXBRQQ29Ye0d0bFDcUxXzNN9GPDjNUuoMp7LupauS3
         tIjiv4cA5NVNWe+0+NH9PW1WWr3/CXPHcEVIvcTIX+6l4/IjeVwfokbmW5v7m/58Rr+R
         efs93sVkF/ZEv4NVxhHn6U7bkQ4rTdACE6PCQUmIzoZ3Uk6yWDy6Yyd7USFUsndrZvC7
         EUvjl7twXuDQN8lyu7Xs8v7hAvCP1kNRvkOetbJL01KQRw4x6tYuR5Hz/UsM5X8SVcEe
         QTpg==
X-Gm-Message-State: AGi0PuYScuHnsXIzmMYvWNuah1mRqr3N72q/pV76X3kF1GFUIhAYcAIx
	gXh0Fur4Grs47Yc1/NVlc9dSWw==
X-Google-Smtp-Source: APiQypLdE3XgkOQdsZ7skOwgbr0+jpPDHHkYRGIHpuO9kIkbSs8cT1F1ifdldVqKmAC4ik2usLfWlA==
X-Received: by 2002:a17:90a:f995:: with SMTP id cq21mr39335143pjb.56.1589471339202;
        Thu, 14 May 2020 08:48:59 -0700 (PDT)
Date: Thu, 14 May 2020 08:48:57 -0700
From: Kees Cook <keescook@chromium.org>
To: "Lev R. Oshvang ." <levonshe@gmail.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
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
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	LSM List <linux-security-module@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 2/6] fs: Add a MAY_EXECMOUNT flag to infer the noexec
 mount property
Message-ID: <202005140845.16F1CDC@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-3-mic@digikod.net>
 <202005121407.A339D31A@keescook>
 <CAP22eLEWW+KjD5rHosZV8vSuBB4YBLh0BQ=4-=kJQt9o=Fx1ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP22eLEWW+KjD5rHosZV8vSuBB4YBLh0BQ=4-=kJQt9o=Fx1ig@mail.gmail.com>

On Thu, May 14, 2020 at 11:14:04AM +0300, Lev R. Oshvang . wrote:
> New sysctl is indeed required to allow userspace that places scripts
> or libs under noexec mounts.

But since this is a not-uncommon environment, we must have the sysctl
otherwise this change would break those systems.

> fs.mnt_noexec_strict =0 (allow, e) , 1 (deny any file with --x
> permission), 2 (deny when O_MAYEXEC absent), for any file with ---x
> permissions)

I don't think we want another mount option -- this is already fully
expressed with noexec and the system-wide sysctl.

-- 
Kees Cook

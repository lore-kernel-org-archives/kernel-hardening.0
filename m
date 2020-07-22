Return-Path: <SRS0=ZCN8=BB=lists.openwall.com=kernel-hardening-return-19419-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CD3C433E6
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:40:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 87CD02065F
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:40:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BtZ9Nvf8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87CD02065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19419-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9397 invoked by uid 550); 22 Jul 2020 19:40:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9374 invoked from network); 22 Jul 2020 19:40:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jjUf3A9HubTVaUqe7Zad+MUemnjZyICfz18It9oZSwM=;
        b=BtZ9Nvf8isLyQCQ50XpXD/ebRCdBjkHCCGnxVM0OZAVUpANRBBMkjIj06Zdw9/XpBn
         ZFD8aNoO8CrwWK2+N4nmMD0rTFkdF72k74MsJNFZWuktshu5ucg9wp2qUVlDzWfUY4Ja
         ol6MqQXlLRetbAhUkjy41VWkXgnqEDPN3tA18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jjUf3A9HubTVaUqe7Zad+MUemnjZyICfz18It9oZSwM=;
        b=ZsJH8CdkP8+Ciyy6tPppcHNysggSGj8/b9g0iFXQk8Wk+dSxsrr+uD9FMvsEsAfqIl
         8uTuu1M1+zRY0tL12p9Mpw+Fi/EaTBx4yUm2QNMO93sHvIvPVAMY/ATSWRIdUJxYfaaC
         q7AOwz0BtG9aWcF4G7q3F61k0l+R21vvOy9w/bFzF+gbi52JTLI/kwRDXKJLUpRdjWbN
         c4ZU+COpNhgqybpy2NWetACGu9Lke6uIFXoRRFzAqxYph2LgpmsbH8aaqsntBUM2lby1
         Al8gV2n2Rhukd2MRuTbx0M6ms7ftKcPF92DSa0cs0YAN3bfNgJyE0YiQE3Nr5rZDFz0R
         OXhA==
X-Gm-Message-State: AOAM531wB7afdoFTvLrCnP9SkGP1mQXXDcq+/7+h3n563tB69U0SN94C
	JAsLIMPp+2+FLX9JKVPcdPQVOA==
X-Google-Smtp-Source: ABdhPJyT2VSdLIe8tOpWuzfYoIvgn4i+cMVfKxosGUgPymW4NU2ZBedNm+ZTGrz2uSKWm+z7tIxFEg==
X-Received: by 2002:a17:90b:338d:: with SMTP id ke13mr906409pjb.60.1595446820815;
        Wed, 22 Jul 2020 12:40:20 -0700 (PDT)
Date: Wed, 22 Jul 2020 12:40:19 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
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
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 5/7] fs,doc: Enable to enforce noexec mounts or file
 exec through O_MAYEXEC
Message-ID: <202007221239.E00125F019@keescook>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-6-mic@digikod.net>
 <202007151312.C28D112013@keescook>
 <35ea0914-7360-43ab-e381-9614d18cceba@digikod.net>
 <20200722161639.GA24129@gandi.net>
 <efb88aab-f9f9-4b66-e7ab-3aa054eec96e@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efb88aab-f9f9-4b66-e7ab-3aa054eec96e@digikod.net>

On Wed, Jul 22, 2020 at 09:04:28PM +0200, Mickaël Salaün wrote:
> 
> On 22/07/2020 18:16, Thibaut Sautereau wrote:
> > On Thu, Jul 16, 2020 at 04:39:14PM +0200, Mickaël Salaün wrote:
> >>
> >> On 15/07/2020 22:37, Kees Cook wrote:
> >>> On Tue, Jul 14, 2020 at 08:16:36PM +0200, Mickaël Salaün wrote:
> >>>> @@ -2849,7 +2855,7 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> >>>>  	case S_IFLNK:
> >>>>  		return -ELOOP;
> >>>>  	case S_IFDIR:
> >>>> -		if (acc_mode & (MAY_WRITE | MAY_EXEC))
> >>>> +		if (acc_mode & (MAY_WRITE | MAY_EXEC | MAY_OPENEXEC))
> >>>>  			return -EISDIR;
> >>>>  		break;
> >>>
> >>> (I need to figure out where "open for reading" rejects S_IFDIR, since
> >>> it's clearly not here...)
> > 
> > Doesn't it come from generic_read_dir() in fs/libfs.c?
> > 
> >>>
> >>>>  	case S_IFBLK:
> >>>> @@ -2859,13 +2865,26 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> >>>>  		fallthrough;
> >>>>  	case S_IFIFO:
> >>>>  	case S_IFSOCK:
> >>>> -		if (acc_mode & MAY_EXEC)
> >>>> +		if (acc_mode & (MAY_EXEC | MAY_OPENEXEC))
> >>>>  			return -EACCES;
> >>>>  		flag &= ~O_TRUNC;
> >>>>  		break;
> >>>
> >>> This will immediately break a system that runs code with MAY_OPENEXEC
> >>> set but reads from a block, char, fifo, or socket, even in the case of
> >>> a sysadmin leaving the "file" sysctl disabled.
> >>
> >> As documented, O_MAYEXEC is for regular files. The only legitimate use
> >> case seems to be with pipes, which should probably be allowed when
> >> enforcement is disabled.
> > 
> > By the way Kees, while we fix that for the next series, do you think it
> > would be relevant, at least for the sake of clarity, to add a
> > WARN_ON_ONCE(acc_mode & MAY_OPENEXEC) for the S_IFSOCK case, since a
> > socket cannot be open anyway?

If it's a state that userspace should never be able to reach, then yes,
I think a WARN_ON_ONCE() would be nice.

> We just did some more tests (for the next patch series) and it turns out
> that may_open() can return EACCES before another part returns ENXIO.
> 
> As a reminder, the next series will deny access to block devices,
> character devices, fifo and socket when opened with O_MAYEXEC *and* if
> any policy is enforced (via the sysctl).
> 
> The question is then: do we prefer to return EACCES when a policy is
> enforced (on a socket), or do we stick to the ENXIO? The EACCES approach
> will be more consistent with devices and fifo handling, and seems safer
> (belt and suspenders) thought.

I think EACCES is correct for these cases, since it's a new flag, etc.

-- 
Kees Cook

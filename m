Return-Path: <SRS0=1BpK=CR=lists.openwall.com=kernel-hardening-return-19806-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE44C43461
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 12:52:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1482922210
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 12:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eTCVIzNm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1482922210
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19806-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20161 invoked by uid 550); 8 Sep 2020 12:52:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20138 invoked from network); 8 Sep 2020 12:52:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RSBroElt/2rd8PC1JxxbAAzGUdGD8+TpQ3WZUmiUhpM=;
        b=eTCVIzNm1ErwySELQBxnMmM/AgczXHFoHr7tAYK0AzvrrFpGaltdTw3BU3s6nbzZwV
         FVze43SwEAqT9SvAQmGOzyCxUMdZtymO/iomH+o46b3/yM0Ox9AJ3+9Xn2WMnWTK0Bc3
         M2VQ+2ueKbAh3cxEBdKEnnfwm2WR+1pf/wzXaClR2OEX+s2dpP4cdruEpT01B2oKaCgT
         WAyhBPyfgKh1zK7exA8S4xxepCiPC2CX0rFJd9/j1ZBlLdrkBQj4c0Vf0Iq6RPftxU89
         +cgdAfBDF5x1mUuE2nCFjBhzD7FADAqHMbVgOC1KJQAzh/bpLmx1qjElc/fALXBLVFU9
         hajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RSBroElt/2rd8PC1JxxbAAzGUdGD8+TpQ3WZUmiUhpM=;
        b=QZUSRY5y/AYoe46NsYSHDQxzn74shMOW0C+LWivfSWpLV1v/9EFipS8B+X+ToZHvTC
         5NNxz2mO1phHaRmwDWVNnPQSvBkwZ2hTxHzUpLwx1wl1C2HqMMavgqf/eXmIlaLIJQJd
         aFTNr9IslDo7YXfwv3z1b+lr3ac5NF80USDkrUPVb0D5xRgVUF/YYNJF5tq+QXlEhzCY
         0BC45hec9+iJuhPkGhB0NhkJ3mr1+j+6v6Lo4Wgj6qi1KAvc767HN88diXaJ0QES9rFi
         4iP25YwmJIcVVRuZtnUlSx6ORyyf40Zy5MVaDgLAqPpV2sIpspR10o2cMaxiBmfD1RL4
         dBdA==
X-Gm-Message-State: AOAM532cZbMilPiqyJ2yZujGkSsEoziqOMLnH3O4xg0+PubVGvE/NBW0
	ItSjJd1xwju2bPbn44kxA3NU5Y3Vlyil06cqocQ=
X-Google-Smtp-Source: ABdhPJxkV3KPZWICtf1txHSRVep4rHIt7AdIIVwPHFJWR6ocRJEX5qRfN+Lfgk+mF/ZkzhvREH+BKcYfiF/pqjxb3rI=
X-Received: by 2002:a9d:7a92:: with SMTP id l18mr16914681otn.89.1599569532734;
 Tue, 08 Sep 2020 05:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200908075956.1069018-1-mic@digikod.net> <20200908075956.1069018-2-mic@digikod.net>
 <d216615b48c093ebe9349a9dab3830b646575391.camel@linux.ibm.com>
 <75451684-58f3-b946-dca4-4760fa0d7440@digikod.net> <CAEjxPJ49_BgGX50ZAhHh79Qy3OMN6sssnUHT_2yXqdmgyt==9w@mail.gmail.com>
In-Reply-To: <CAEjxPJ49_BgGX50ZAhHh79Qy3OMN6sssnUHT_2yXqdmgyt==9w@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Tue, 8 Sep 2020 08:52:01 -0400
Message-ID: <CAEjxPJ6ZTKeunzJvWf_kS3QYjca6v1yJq=ad-jCCuDSgG6n60g@mail.gmail.com>
Subject: Re: [RFC PATCH v8 1/3] fs: Introduce AT_INTERPRETED flag for faccessat2(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, Christian Heimes <christian@python.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Deven Bowers <deven.desai@linux.microsoft.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, 
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-integrity@vger.kernel.org, 
	LSM List <linux-security-module@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2020 at 8:50 AM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Tue, Sep 8, 2020 at 8:43 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> >
> >
> > On 08/09/2020 14:28, Mimi Zohar wrote:
> > > Hi Mickael,
> > >
> > > On Tue, 2020-09-08 at 09:59 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
> > >> +                    mode |=3D MAY_INTERPRETED_EXEC;
> > >> +                    /*
> > >> +                     * For compatibility reasons, if the system-wid=
e policy
> > >> +                     * doesn't enforce file permission checks, then
> > >> +                     * replaces the execute permission request with=
 a read
> > >> +                     * permission request.
> > >> +                     */
> > >> +                    mode &=3D ~MAY_EXEC;
> > >> +                    /* To be executed *by* user space, files must b=
e readable. */
> > >> +                    mode |=3D MAY_READ;
> > >
> > > After this change, I'm wondering if it makes sense to add a call to
> > > security_file_permission().  IMA doesn't currently define it, but
> > > could.
> >
> > Yes, that's the idea. We could replace the following inode_permission()
> > with file_permission(). I'm not sure how this will impact other LSMs th=
ough.
>
> They are not equivalent at least as far as SELinux is concerned.
> security_file_permission() was only to be used to revalidate
> read/write permissions previously checked at file open to support
> policy changes and file or process label changes.  We'd have to modify
> the SELinux hook if we wanted to have it check execute access even if
> nothing has changed since open time.

Also Smack doesn't appear to implement file_permission at all, so it
would skip Smack checking.

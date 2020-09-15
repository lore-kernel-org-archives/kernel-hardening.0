Return-Path: <SRS0=a7Oq=CY=lists.openwall.com=kernel-hardening-return-19898-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87B6C43461
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Sep 2020 13:32:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 96629206BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Sep 2020 13:32:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96629206BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19898-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4009 invoked by uid 550); 15 Sep 2020 13:32:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3986 invoked from network); 15 Sep 2020 13:32:42 -0000
X-Gm-Message-State: AOAM531Gonz4BIgnYvFQdLsRrw8PtoOxubbxp7U9ilDSKHfvUNR/e+GU
	GwMPnPh3x0hCOGZZNtFBXMqiVgKoRNE/91KRG+4=
X-Google-Smtp-Source: ABdhPJxxLmMCN4A/oxqNJBXyjnHh2EThJJR2LF/8Sz6ABSTqKRD1ROg//n2YBFK6xkQVViDw3D8KsqM5aPAmkXBsQb0=
X-Received: by 2002:aed:2ce5:: with SMTP id g92mr5576894qtd.204.1600176747244;
 Tue, 15 Sep 2020 06:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200910164612.114215-1-mic@digikod.net> <20200910164612.114215-3-mic@digikod.net>
In-Reply-To: <20200910164612.114215-3-mic@digikod.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 15 Sep 2020 15:32:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2bhKp8pHYP1nDg__pgPoNssVUkLo3y6bFiGjCKv-c0cA@mail.gmail.com>
Message-ID: <CAK8P3a2bhKp8pHYP1nDg__pgPoNssVUkLo3y6bFiGjCKv-c0cA@mail.gmail.com>
Subject: Re: [RFC PATCH v9 2/3] arch: Wire up introspect_access(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Brauner <christian.brauner@ubuntu.com>, 
	Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Deven Bowers <deven.desai@linux.microsoft.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-integrity@vger.kernel.org, 
	LSM List <linux-security-module@vger.kernel.org>, 
	Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VlNM/dz8CyjDd73UFKdheylTiZF2qrNzrdVdElLiIN4tyfwlYfz
 Ok5TSez6kaPzUHHgd4tbSeDPocajTukDzlqjXzCHoVSNpeOMOOx16n5fwK9wYX9M4VpVEmD
 E5EtxVa7qJRkTHLti7xLLEMrvesYGPvn6iwT+ssuWySp3dL5FH0i8CQuo/lwy9FsaP8Z0Ws
 T+DXOhEhHbxs4pesyhoBw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aC1okdJjcqk=:nUzDxpmINupUo3KoLbMieA
 QoSj4cmohf31op9BBd+iRq5M5/jPuaYhgCG9vDDBeLwxQoBz6T1DAF9w8LVOjnQutD7Gzw/Be
 HWPlaswugYINcXsTif4gDd8XOSD/jnnyEgais7fuEAbnyFNPH4Zy7EGM67NTwtbjcSQnSpv6e
 HIJ4jaELUxvSZkwnqrpntpUNQAxrApZquY0zbS4N4ec0IBfHxaTPnFWKpbEUwn9u7kJyBx5GK
 HRXbCeLBNnq174LfZY+n/83ETNR8B38Q68MZh2A4mha2vsFoIlpaW5047kFo+ZRx9kziq5svr
 KJylN1kFy+oDABnkeJby+/qVHVya0bkgoS7j3faIainvCuvBNna5dYeWMuWhxS/hgZJND64NG
 iXd39PlDQOt2N6fU8JmzzXA5LPfvPnbplwwEl+UPH7fzV9k4US3MBpxdCbqiwDUlH2I/SWrMg
 q2W8WmljnBCnke3gnoDETKGyn3zW+sYaATQe41r+sXJZB6sAejUEX3FBRGfqxkwEK7a6Ydidb
 /FPbwxYd6uKdyrtM5qtLyTiRt7FK7e0SdrjoWNcj9rjncu86UHw37ryr+cIfnRD9XdHiJ4R2W
 K56ZcEfdXQt3gDwrM36HSKZ0UXpMmOilqXCcbdbpXwBcoL9fGC0lWkmubvAYPtd2ltUxM3nFC
 mHpe5yFBrkaPH6rCFqg5p937aJREPpL8m3MfbodXwfHXFBHZw3d+ls0ZW5WXLsY1LSymnilwo
 f6tlbgnZjDUl5rXFV5vcqPgzDbt7sg7PTVPzGT0NHHyTu7dJlc6NsTP0EsgtysAMRxR6/EOyG
 6N/sr93wHK4lrncxF+IZlhBoVMhLvevo9MDaJ+MWCufK4lmjcm9bdfeBMzBqmCWddlaglEzfV
 zuUll7FmNup1nL6fOtHZkyg58uIZVX5uldQm35w0vdLNQJuDKpnpGK+J6Mgt3fDQGveXAaWtE
 OeCPOEtCoveH4FzjoP6HxGyAdxuVj1IF786TDyib1q/ma2QdKLylE

On Thu, Sep 10, 2020 at 6:46 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>
> Wire up access_interpreted(2) for all architectures.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> ---
>
> Changes since v7:
> * New patch for the new syscall.
> * Increase syscall numbers by 2 to leave space for new ones (in
>   linux-next): watch_mount(2) and process_madvise(2).

I checked that the syscall calling conventions are sane and that
it is wired up correctly on all architectures in this patch.

Acked-by: Arnd Bergmann <arnd@arndb.de>

I did not look at the system call implementation or its purpose though,
as that is not my area.

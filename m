Return-Path: <SRS0=POM6=E3=lists.openwall.com=kernel-hardening-return-20445-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF7BC388F9
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 07:01:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 34BF722206
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 07:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SXMdW3Iq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34BF722206
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20445-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1138 invoked by uid 550); 21 Nov 2020 07:00:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1104 invoked from network); 21 Nov 2020 07:00:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qSt/XnTloXSnWYtWCxId4OBXpP28x7HyJlEM0VTTxfw=;
        b=SXMdW3IqDbJ6iWw8IZ9Q5CNHq9VhrWbVp/EFAUzmCzAPgt7dcdixohikYsRS8jBWb1
         kjZbjAisDfdp9lwbGwx8t8ITuW2ZvTjirm7OuW6PzkBN++x9KgW/YZWIVfeW6e6mlx3U
         /lumB7FQ98t3ujt+mefcDxCxr8UBoHSfT7/x/vIP0AqU4k0hMZAjxoIG9CjXFXs8CFQQ
         HZdfjKvCNoGFCrGQCY8jcCvrkzlnJsbl7lsY/u+ZRYaynCCRUhJ+Qr2rZkAfpo8ZBl7g
         IhCZE31GiyxOfhCWdnhAONlyo2d8Cy1QH+CApFXoypZopMLIK39U9YnN+CMIrVgDo1yp
         gxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qSt/XnTloXSnWYtWCxId4OBXpP28x7HyJlEM0VTTxfw=;
        b=oYbUST7qGN17PlgzfYCECrW2gzcn6QT5iy/g/OALNZx3hEptUc8CrxJxNldSzJkzFM
         vxGvQUMyxKmFGt2XDGal1s1l2DChJzi08BiM6DcPtBf3jZwHUD1MAb9uSaTH3YZKBxS3
         LV3r9xLGJEeQQRtfDW9imjysUdbiPhSDAwSbJrwtOeHSChjaOPpA+7uzTUUb9uVwQyH7
         I2euYHV3i2eVOb0TMm46366T7p1lj3tGSqk7u6mvFk3baUG6i6igmD96BQvgb+H+WNCB
         sK/Z2L4djcLIdMsQsyOUp+3x+jT6S3mlwOk4ChXB7ge+3mx0VOQiauIm6etLY0ZXGXg3
         TTvw==
X-Gm-Message-State: AOAM531aByZZbRexWkbQ8v7T8SiXUOC4811EtWFI+Luq/Xlfn7kOKygm
	daZP4zHr3usSD0DIiENA5GnAQ/eZye3y9fRvGEDLAw==
X-Google-Smtp-Source: ABdhPJysESVBpzmb8AIe4IsYMGTwUSB/SEEqglyDLyhegKtUN1uX2v4ambD1WjsgatbnwE0AiCnynPiP1Rb9iZe/YZ0=
X-Received: by 2002:a05:6512:348e:: with SMTP id v14mr8698488lfr.97.1605942041000;
 Fri, 20 Nov 2020 23:00:41 -0800 (PST)
MIME-Version: 1.0
References: <20201112205141.775752-1-mic@digikod.net> <20201112205141.775752-13-mic@digikod.net>
In-Reply-To: <20201112205141.775752-13-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Sat, 21 Nov 2020 08:00:00 +0100
Message-ID: <CAG48ez0S1_jd0YzXZ9tx94gU0sw-WeXgG336d=3YP7+iZvRgaA@mail.gmail.com>
Subject: Re: [PATCH v24 12/12] landlock: Add user and kernel documentation
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Jeff Dike <jdike@addtoit.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 9:52 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> This documentation can be built with the Sphinx framework.
>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Reviewed-by: Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>

Reviewed-by: Jann Horn <jannh@google.com>

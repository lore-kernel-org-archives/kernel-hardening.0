Return-Path: <SRS0=RuJk=EE=lists.openwall.com=kernel-hardening-return-20299-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC3CC4363A
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:07:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C4D532071A
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UDRPLu9m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4D532071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20299-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3884 invoked by uid 550); 29 Oct 2020 01:07:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3804 invoked from network); 29 Oct 2020 01:06:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bPMDf0qf5u7i+D1hct4Y8ywTPSNEiqZnANVXp2csHmo=;
        b=UDRPLu9msJZF3jU3f0cfRMmMUjv4al6mEdH+doXP3CJs1E+meQHwswUn6FfxeU4M7Y
         mdjF6dlxs/r9X+nsG+jvBBpuJoeemwz7oZzHEH8cu2FuE4WoJMkmPz/Ji0yhM4+WiFtB
         rhpBehRSmY/cTeZk76/aJgyzXOLL3NJE1/q4NlCTkpqRI97pcMZ+gNtjS3uoF4nuh7W1
         yw24PiXpzrFEiT3OI82ePRsw7PnnCJjT7Cw+g66nh4wZX1yx+HybJu5UCEhtHD658mi+
         886WmiZsQzGj6z4/CpD39D+FU4YLDTEf8HsVVyfPaptpyJrsYS5a5QKE4zded/CZpn7z
         MwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bPMDf0qf5u7i+D1hct4Y8ywTPSNEiqZnANVXp2csHmo=;
        b=RtVZgWrliDnROSGuYQ71rWG7UkU8gwn8wRo/P5rudWT7qwbNLVvAXKo59NyYvuUiaP
         Ejf9SBUMRV2eMJTDpKtzyxbSpLZkb7iioh/E7qN2+ufBH9OZA4px/dfEpZO6GE6W5LOa
         paYoxpJN8vSRxJgSS//u2x3+mAk7eGhGVx5KgpofaPf6IOmXJFwXIGOz3WFfGDry5wQB
         YVWLCDn9o4LPavKketHiCUOsGLvdue5vO/oNi4DXsR5WQY8putpqgQ/0cyI/uK8KSXEb
         8jFL/BCYgwl82ynsNKb6eDOqVm5Jf581C99MqClLp2lsE3pKrNFBBfThKafUFC8nATl7
         dHZg==
X-Gm-Message-State: AOAM531JBoc0LfrD/8BKizmBv2m9LvI2d7r7LGRVFt/qJXfyt7J5U+QY
	cOOocimClrQR/XYNqWQRCzSBzTUl9XqhId+2hhahIQ==
X-Google-Smtp-Source: ABdhPJzDdFVnRlhR1ZLyXcR/6gy+QFM2Be7EL54Ws7cTI4I+QtUU5EktO2FmKhpKLEYWon1ieCyZ/uOiqgKG+1NYZAk=
X-Received: by 2002:a05:6512:1182:: with SMTP id g2mr584148lfr.198.1603933608096;
 Wed, 28 Oct 2020 18:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201027200358.557003-1-mic@digikod.net> <20201027200358.557003-7-mic@digikod.net>
In-Reply-To: <20201027200358.557003-7-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Thu, 29 Oct 2020 02:06:21 +0100
Message-ID: <CAG48ez0venF9OnBG82yc8U+px1LUfUU498f1kJxYMu0hcU0+-A@mail.gmail.com>
Subject: Re: [PATCH v22 06/12] fs,security: Add sb_delete hook
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

On Tue, Oct 27, 2020 at 9:04 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
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
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>

Reviewed-by: Jann Horn <jannh@google.com>

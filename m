Return-Path: <SRS0=axNg=4P=lists.openwall.com=kernel-hardening-return-17975-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC54C11D3D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 16:52:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC8022469F
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Feb 2020 16:52:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h2ckek+4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC8022469F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17975-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19948 invoked by uid 550); 27 Feb 2020 16:52:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19915 invoked from network); 27 Feb 2020 16:52:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gp52pRjsJhSA+Hsa491NiMGo7ZzN8vh48sP/xPZjY7A=;
        b=h2ckek+46BKub8OVUhke3FC/nXyQRCv+YQ5y9CV5RbavgOyX2emB9a6/jb7odtCAKM
         5ltcv6eQIF7Ic86LAqy26c5McXL14zfj7SHokiEMytQXVSGvnJlTtIuSNHkSOQkFWjRP
         Mu7gYWpvSfwVaBUOsaWiRTp0YvOLWDionRgvz1JkZwXSBMY3V3b96qCMcMlj0mUxU56T
         mo9uGvza0log5cdDTTy2ztxkZVwF2Oog57jDbqdSKdT3X6QIagU/KCEypSCKV9XaPvzj
         wCtt3eoq7JH1jvdYAAnC4fMTn7+3EHxTnrbfi6sRJvcEaM84OCdYDwSLRgwprggtt3Y2
         wEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gp52pRjsJhSA+Hsa491NiMGo7ZzN8vh48sP/xPZjY7A=;
        b=PAz0tMs4BkQsOuzXyiHWw6/e+dxYlD9YZ+5DZve8shrSmh0vPeFaDGbhsc6N3jTyYT
         9C7niZ4DNeXbYe9yWbM5VI/+FhLiOY/y2FU1SEufRr7xLAogqItNH2A4CG/gKLTvAGTF
         mB2F2GIf6xsL4/eMPrGRqbmIC4PjJiBuoRhcrXZDIur/IMwAkydo676Qv6H8ydoEKdj3
         zkqdoFT1minprJXdQEriEnjYd3RIzu68hz9zCMXqcznNn9lhp5zZnUZH+0jg8fJ/gVoT
         Icy23RHtHSEASPFjOFl6t4btA6srdc6oofaB5EAaWBwPwkD9mg3xDykqUH0rE0XZvtE9
         kQ9w==
X-Gm-Message-State: APjAAAWKf09bR1vduzuRh3FeXPqGIhCLNWe7AgXyn6NT23iJf6ZCzckb
	OYu8YQOK4Rn5AFEthN8/ldvfWZljtBTUFbGuiFqy7A==
X-Google-Smtp-Source: APXvYqwtYAjsjMZBmazOMBlU4tgSOoeRD3FzHInhjMiQQq9Hs9Q8FYDFJIJz944uJE8l8reZMl0eKMk+IJoxnZLWgp0=
X-Received: by 2002:aca:d954:: with SMTP id q81mr4104431oig.157.1582822337290;
 Thu, 27 Feb 2020 08:52:17 -0800 (PST)
MIME-Version: 1.0
References: <20200224160215.4136-1-mic@digikod.net> <20200224160215.4136-6-mic@digikod.net>
 <CAG48ez36SMrPPgsj0omcVukRLwOzBzqWOQjuGCmmmrmsGiNukw@mail.gmail.com> <34319b76-44bd-8915-fd7c-5147f901615e@digikod.net>
In-Reply-To: <34319b76-44bd-8915-fd7c-5147f901615e@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Thu, 27 Feb 2020 17:51:51 +0100
Message-ID: <CAG48ez1ETFhAZE1A9x=zB=b+t=pFYp3Yc0j8psFQhGwFRdDu2A@mail.gmail.com>
Subject: Re: [RFC PATCH v14 05/10] fs,landlock: Support filesystem access-control
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	"Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, linux-doc@vger.kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2020 at 5:50 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> On 26/02/2020 21:29, Jann Horn wrote:
> > On Mon, Feb 24, 2020 at 5:03 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.n=
et> wrote:
> >> +static inline u32 get_mem_access(unsigned long prot, bool private)
> >> +{
> >> +       u32 access =3D LANDLOCK_ACCESS_FS_MAP;
> >> +
> >> +       /* Private mapping do not write to files. */
> >> +       if (!private && (prot & PROT_WRITE))
> >> +               access |=3D LANDLOCK_ACCESS_FS_WRITE;
> >> +       if (prot & PROT_READ)
> >> +               access |=3D LANDLOCK_ACCESS_FS_READ;
> >> +       if (prot & PROT_EXEC)
> >> +               access |=3D LANDLOCK_ACCESS_FS_EXECUTE;
> >> +       return access;
> >> +}
[...]
> However, I'm not sure this hook is useful for now. Indeed, the process
> still need to have a file descriptor open with the right accesses.

Yeah, agreed.

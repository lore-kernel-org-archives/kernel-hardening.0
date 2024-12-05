Return-Path: <kernel-hardening-return-21881-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 666DAE77172
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2024 03:34:07 +0000 (UTC)
Received: (qmail 7581 invoked by uid 550); 5 Dec 2024 03:33:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7552 invoked from network); 5 Dec 2024 03:33:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1733369625; x=1733974425; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqqlC+ZUU04wDK2N54+0ftqA1cSI7m49jZLokKLp/0E=;
        b=E/tUvFAhGtd/H0b+Nsvd+Xk9nKd1jV3jADOUSKAqnb+3ZjTQUaUH8qg1IjeZ+nt4TO
         r4DCN7twpYUSbPLqoUYUeIng65a59/aO100oCgyhB6fCzSNxnJ9KU0V2+WVPZDp1qe50
         ZsNakrxa2tZ75Bdb0Spc2ErTEJUtfLXnd65OuTh4mQvQ/kMjRu/r/qdhyUP23m934kye
         Uptj8qJ19NCmdwlFM27lcyoDTuN659ElrztBwbBTPw2HQ1QdtX6EfighBGWX//lNtHN5
         TKwWqGtxHDw7ldCc/dH9EU5Qy7F1rSp90pKU8X7AOTiwH/DKwXS3CCIf1jkrQHu8GZ7C
         Zqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733369625; x=1733974425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqqlC+ZUU04wDK2N54+0ftqA1cSI7m49jZLokKLp/0E=;
        b=gvRWDt/S5cpIZF6CYlA7FQp2x2BOJ4KlEtlJMpTWjv1qO8KCjPJLpX+yTFKf1ELfpD
         eOpJLNZF86woBA8JXZ3c7o+vkIC1NRHDQX+KUEdzA33TJg9tzNo4lYUVnwYn8r+Fb8cD
         UA7kgrD2s23bOlgt7g7rCmrRdSrEXCCqBwMJhsR42bG/3VBOJifbttSXQh8FVCxWid8y
         meK/2ChTrznKvl58GI8DOW/zL0WnKvFzOhpYvzee0RX6u/X/sHfs0kwbYdGEsREvbPzK
         hsKfP6fbhTq65Wx4WJO1g0CPD7ygWIvespVdNqN7kJWFA2OeEoxFkM7eCFo93rgxf0K/
         UN6g==
X-Forwarded-Encrypted: i=1; AJvYcCWWBnbsI/6txxeqy0vjNpAVf73gBlxtw+K4GnnL0r3rvi4NY/Qzud+aHm9xVYFN9odsWnQhweHtqFB12OLYt2Dm@lists.openwall.com
X-Gm-Message-State: AOJu0YxfVjZE9DBZRIIPYhU1PEmeKAX05zUPgbtAU33MCQ2GSy0rAySr
	/woc9wiAAQ3TE9z3PnLocPigM2EizqO3rJpC2AjjqDmKZG5OCJIWg3FRfgNj9NmLhS5mc5g9CT+
	ctH+zkl1Huc6V/YeH2vKzB9LdjozSuTMluR6V
X-Gm-Gg: ASbGnctBeD7bC2tOZUrpdNdeVp8mqUxxZMFQTqZ5ZA+XzQXfkGuYZzpxN0jp/vs2GWQ
	IaPIAka7G3IphwQdL68HuUzFgEFsT8Q==
X-Google-Smtp-Source: AGHT+IFIW0nv4nMp+xB3hRxH7jiqJFLJ+/vbSzLjYlJYf27dkS9U79OHIOtdDmrXE95yoa1diQrswqexP0FD2HzbsL0=
X-Received: by 2002:a05:6902:10c1:b0:e2b:dbf6:34ca with SMTP id
 3f1490d57ef6-e39d43740bdmr7490115276.36.1733369625457; Wed, 04 Dec 2024
 19:33:45 -0800 (PST)
MIME-Version: 1.0
References: <20241112191858.162021-1-mic@digikod.net> <20241112191858.162021-2-mic@digikod.net>
 <CABi2SkVRJC_7qoU56mDt3Ch7U9GnVeRogUt9wc9=32OtG6aatw@mail.gmail.com>
 <20241120.Uy8ahtai5oku@digikod.net> <CABi2SkUx=7zummB4JCqEfb37p6MORR88y7S0E_YxJND_8dGaKA@mail.gmail.com>
 <20241121.uquee7ohRohn@digikod.net>
In-Reply-To: <20241121.uquee7ohRohn@digikod.net>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 4 Dec 2024 22:33:34 -0500
Message-ID: <CAHC9VhT9sRXauYX+=21MUdOmfTZL4=sdGQsXojJjjTsdui+F_g@mail.gmail.com>
Subject: Re: [PATCH v21 1/6] exec: Add a new AT_EXECVE_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Jeff Xu <jeffxu@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Serge Hallyn <serge@hallyn.com>, Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>, 
	audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 8:40=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
> On Wed, Nov 20, 2024 at 08:06:07AM -0800, Jeff Xu wrote:
> > On Wed, Nov 20, 2024 at 1:42=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > > On Tue, Nov 19, 2024 at 05:17:00PM -0800, Jeff Xu wrote:
> > > > On Tue, Nov 12, 2024 at 11:22=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <=
mic@digikod.net> wrote:

...

> > > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > > index cd57053b4a69..8d9ba5600cf2 100644
> > > > > --- a/kernel/auditsc.c
> > > > > +++ b/kernel/auditsc.c
> > > > > @@ -2662,6 +2662,7 @@ void __audit_bprm(struct linux_binprm *bprm=
)
> > > > >
> > > > >         context->type =3D AUDIT_EXECVE;
> > > > >         context->execve.argc =3D bprm->argc;
> > > > > +       context->execve.is_check =3D bprm->is_check;
> > > >
> > > > Where is execve.is_check used ?
> > >
> > > It is used in bprm_execve(), exposed to the audit framework, and
> > > potentially used by LSMs.
> > >
> > bprm_execve() uses bprm->is_check, not  the context->execve.is_check.
>
> Correct, this is only for audit but not used yet.
>
> Paul, Eric, do you want me to remove this field, leave it, or extend
> this patch like this?
>
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 8d9ba5600cf2..12cf89fa224a 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1290,6 +1290,8 @@ static void audit_log_execve_info(struct audit_cont=
ext *context,
>                 }
>         } while (arg < context->execve.argc);
>
> +       audit_log_format(*ab, " check=3D%d", context->execve.is_check);
> +
>         /* NOTE: the caller handles the final audit_log_end() call */
>
>  out:

I would prefer to drop the audit changes rather than add a new field
to the audit record at this point in time.  Once we have a better
understanding of how things are actually being deployed by distros,
providers, and admins we can make a more reasoned decision on what we
should audit with respect to AT_EXECVE_CHECK.

Beyond that it looks okay to me from a LSM and audit perspective, so
feel free to add my ACK once you've dropped the audit bits.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

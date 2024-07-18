Return-Path: <kernel-hardening-return-21797-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 7DEA4C3DA5D
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jul 2024 01:03:42 +0000 (UTC)
Received: (qmail 16050 invoked by uid 550); 18 Jul 2024 01:03:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16030 invoked from network); 18 Jul 2024 01:03:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1721264598; x=1721869398; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DvCNFOJURn8U74iwm+vc54yZXB4520PPHveux2N1NI=;
        b=PM6uDV0Q/zjTldvEXnRm02+MX0UALHyMww2SIe36P5zxFzp/+w/IWVdR5pr3Axau55
         kwMp8tlWh5E9tnj6uAGw/5+/2ItZXAqyY74GP4tFurA3jF5iKFDxP9B1DoVF1wk3m1FI
         TweGbiyRZo3VDc1dhuEL/Fg2WZqgN0muYh0CujL1BFpH9JoaC8kzlhJ2bW1b5ZSMEpsX
         FkPRilPwAJoWZ3KN8Rjk7iMhIVKEFuEqSusOxiCS0sWDThUQ2TS+n7DW5jw82OlF92Ff
         cG9KZg4/sYKwNHjF+iyqZcIFjcowBk3G2ePxDmfGzhexlcqSbUcz74oF67RC5PRzcRoA
         TXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721264598; x=1721869398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DvCNFOJURn8U74iwm+vc54yZXB4520PPHveux2N1NI=;
        b=ZioRn6X0KB9SngcWRQTVByj4nTQEqdCJP/MWAl3/+W/CKe96f6LACWD8Rb+WGRSoCc
         PUAY3utNXqF/seSRHFb7z9u08GzVU/ipY84DJJEDfojqjgzmIqcwYuqvEPbLmSGf8cIe
         hAkUksk7Imuh8P1oa31kMZB5n19Ld+/U9YdTheZB4N/6pW64DE19BtRFuZoBGDyvKTft
         3xLCCIytU8GVjqjs91TwNgZjq32Lyv2ZeVr+cSyrk1mA7N5eiWlMzZ4x2IdFtEZOVZIU
         XW6hv8ZYp9U0mv47Mpbkk7woEKNPt3bP6xSWPYRfhfnl59Uu7cm8PIXv/Qsgv4UeJ2Ve
         TesA==
X-Forwarded-Encrypted: i=1; AJvYcCXhx7Fevjzsag9CF74D8oVHzPoPUU2Bncyz69UYpCvBDBq/ARPoMN7ddgK0GVtQR1d+j5rzAJfMgaGVLIsj1RN9cDt9DcSFwN46qC8QD6CyaHcQiw==
X-Gm-Message-State: AOJu0Yzxvm2O5f51y22nZ9VCg/hJQlBxtjQKi+AnRO3+E0kfWYnRP3wx
	PYlFFrg/ZmJdrWf1DKgLinYKM+2LfqcuLDvIZoihgaZrocSp90OPjiifhlrQJyCCqe9w53z4grl
	M0Zjl5y2Ke9eC/u3Oxqk+mSDrZ8nhlIrLGOyo
X-Google-Smtp-Source: AGHT+IE7SBwV2lQaXPjuvVAVH1UzPNTxYBnnea3hS+FDItUKjfyoEirYJPBEWFBIzD4Kcr81i9vTbZRgtB1tPcSWRYA=
X-Received: by 2002:a50:f617:0:b0:57c:9eef:e54 with SMTP id
 4fb4d7f45d1cf-5a155e8f87cmr1229866a12.5.1721264588545; Wed, 17 Jul 2024
 18:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <a0da7702-dabe-49e4-87f4-5d6111f023a8@python.org> <20240717.AGh2shahc9ee@digikod.net>
In-Reply-To: <20240717.AGh2shahc9ee@digikod.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Jul 2024 09:02:56 +0800
Message-ID: <CALCETrUcr3p_APNazMro7Y9FX1zLAiQESvKZ5BDgd8X3PoCdFw@mail.gmail.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Steve Dower <steve.dower@python.org>, Jeff Xu <jeffxu@google.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Jul 17, 2024, at 6:01=E2=80=AFPM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>
> =EF=BB=BFOn Wed, Jul 17, 2024 at 09:26:22AM +0100, Steve Dower wrote:
>>> On 17/07/2024 07:33, Jeff Xu wrote:
>>> Consider those cases: I think:
>>> a> relying purely on userspace for enforcement does't seem to be
>>> effective,  e.g. it is trivial  to call open(), then mmap() it into
>>> executable memory.
>>
>> If there's a way to do this without running executable code that had to =
pass
>> a previous execveat() check, then yeah, it's not effective (e.g. a Pytho=
n
>> interpreter that *doesn't* enforce execveat() is a trivial way to do it)=
.
>>
>> Once arbitrary code is running, all bets are off. So long as all arbitra=
ry
>> code is being checked itself, it's allowed to do things that would bypas=
s
>> later checks (and it's up to whoever audited it in the first place to
>> prevent this by not giving it the special mark that allows it to pass th=
e
>> check).
>
> Exactly.  As explained in the patches, one crucial prerequisite is that
> the executable code is trusted, and the system must provide integrity
> guarantees.  We cannot do anything without that.  This patches series is
> a building block to fix a blind spot on Linux systems to be able to
> fully control executability.

Circling back to my previous comment (did that ever get noticed?), I
don=E2=80=99t think this is quite right:

https://lore.kernel.org/all/CALCETrWYu=3DPYJSgyJ-vaa+3BGAry8Jo8xErZLiGR3U5h=
6+U0tA@mail.gmail.com/

On a basic system configuration, a given path either may or may not be
executed. And maybe that path has some integrity check (dm-verity,
etc).  So the kernel should tell the interpreter/loader whether the
target may be executed. All fine.

 But I think the more complex cases are more interesting, and the
=E2=80=9Cexecute a program=E2=80=9D process IS NOT BINARY.  An attempt to e=
xecute can
be rejected outright, or it can be allowed *with a change to creds or
security context*.  It would be entirely reasonable to have a policy
that allows execution of non-integrity-checked files but in a very
locked down context only.

So=E2=80=A6 shouldn=E2=80=99t a patch series to this effect actually suppor=
t this?

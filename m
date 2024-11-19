Return-Path: <kernel-hardening-return-21862-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id C1157D4417A
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2024 15:54:11 +0000 (UTC)
Received: (qmail 18164 invoked by uid 550); 19 Nov 2024 15:53:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18141 invoked from network); 19 Nov 2024 15:53:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732031627; x=1732636427; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZBz6My2fl2cEQ/H4m7spItLuifNL3YkZ0yddOy41YQ=;
        b=ldFhQikpGS4eQVfNH2Lux7/8IqPpc349mYaXpHOwdQr4V48tmenWh3955LW7A3g5cS
         Wb8dCJTriEWipeaLg2ksTgMwyQBN+Z9PveAEGwC5BWrxrYKD0AniIbYGaHFtL4JlzIFX
         tobr8HUBYNcu088N4233aWysFq2oxfK4Yy6SetuI5rzoqnmpCrosECZiDYejh2yrCj7z
         AXXrC3Ey+lWnoS192UFUJGx92gE1NCuXATW7wKh+agnqqBb2XbywYMVV84zOU0QYzU7W
         pbtPBYD2CNJU08fGVij09qN3CieVJpoehCSj8Blve56ucgOEV791q44AtKOlyoNdMrRJ
         T5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732031627; x=1732636427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oZBz6My2fl2cEQ/H4m7spItLuifNL3YkZ0yddOy41YQ=;
        b=bJRYHrrvB0Ki39UK4y7inJSdWRe9rMeZxaMWRhWQiNrjBVnQxSpGYPN7U3iiDLuk0E
         6uNwzSNp28Nk/6VTlm8dUhLGMicrvwNoU7yIlsk/eW1gY9GWW9fbEVdUe+pmVsqTr8eB
         G6zoggYWEp42z6EAelAKkMzV/FTcMVPpMycKEJ10edZ00Lu8ziuNujfBKF0jEdabvkew
         lgG2yiASYrOatZVIQrGu0AvRyryJ6gb3+oK4hu15Fua3RV/B4BBMO2tQv31857WUbvs2
         PEA1rQnyDDr9ZtY3ieoyRh5i9hSf59KjXxfJG8+70uTl7zXlvTwoQLJjWW7cPNZR1Q8A
         BKug==
X-Forwarded-Encrypted: i=1; AJvYcCVixuWalJqAB3kFz+42/aE026j2oJJDOH5Lyhp5aCbPGK/vGJhNeagBnLVLnHdH8RsRDem686P4+4IGO+9fP6bG@lists.openwall.com
X-Gm-Message-State: AOJu0YyOflRRhMqOO6O5ZEFEOV/HqQiBTiB8IMYLujnwvau/BMiKGOV/
	3M95afSERKIgph6JHLqX9hWVe/bazMtGDxanJwsa3fMLvY9ToJWamPctPZrPxxXlCvX7fSf6fP+
	7dh9ABF7KUmptyIA2czkZCXm+db/qI42didtW
X-Gm-Gg: ASbGncuXBNljDLpTCQHIUeQoaxdWvg/KqSmhTCaAM0g9OrlpoxBeMILiK+9qzenLN1H
	F7Nu3Od8b4NVyiaeQsad7vDz7veJqcDyJeC46wDNxyCr5IcgUamrVZz1rfXs=
X-Google-Smtp-Source: AGHT+IGNsuMEPDGgLQcJBGgUTcQNAXs25llr0/NFfx7zpUAdIJ2qG87STQ6ogH4Jn3C0zEhl2cmBRbcH53+WD7m9EI4=
X-Received: by 2002:aa7:c251:0:b0:5cf:f20c:bdf0 with SMTP id
 4fb4d7f45d1cf-5cff20cbec4mr2276a12.4.1732031626961; Tue, 19 Nov 2024 07:53:46
 -0800 (PST)
MIME-Version: 1.0
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com>
 <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local> <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
 <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com>
 <CAG48ez1KFFXzy5qcYVZLnUEztaZxDGY2+4GvwYq7Hb=Y=3FBxQ@mail.gmail.com>
 <CA+CK2bCBwZFomepG-Pp6oiAwHQiKdsTLe3rYtE3hFSQ5spEDww@mail.gmail.com>
 <CAG48ez0NzMbwnbvMO7KbUROZq5ne7fhiau49v7oyxwPrYL=P6Q@mail.gmail.com> <CA+CK2bByXtm8sLyFzDDzm5xC6xb=DEutaRUeujGJdwf-kmK1gA@mail.gmail.com>
In-Reply-To: <CA+CK2bByXtm8sLyFzDDzm5xC6xb=DEutaRUeujGJdwf-kmK1gA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 Nov 2024 16:53:10 +0100
Message-ID: <CAG48ez3zNWJY=3EcuS1n1cFyujUO7CXAYe7=H48Ja_WmdL_PYw@mail.gmail.com>
Subject: Re: [RFCv1 0/6] Page Detective
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	akpm@linux-foundation.org, corbet@lwn.net, derek.kiernan@amd.com, 
	dragan.cvetic@amd.com, arnd@arndb.de, gregkh@linuxfoundation.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, tj@kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, shuah@kernel.org, vegard.nossum@oracle.com, 
	vattunuru@marvell.com, schalla@marvell.com, david@redhat.com, 
	willy@infradead.org, osalvador@suse.de, usama.anjum@collabora.com, 
	andrii@kernel.org, ryan.roberts@arm.com, peterx@redhat.com, oleg@redhat.com, 
	tandersen@netflix.com, rientjes@google.com, gthelen@google.com, 
	linux-hardening@vger.kernel.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 4:14=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
> On Tue, Nov 19, 2024 at 7:52=E2=80=AFAM Jann Horn <jannh@google.com> wrot=
e:
> > On Tue, Nov 19, 2024 at 2:30=E2=80=AFAM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > > > Can you point me to where a refcounted reference to the page comes
> > > > from when page_detective_metadata() calls dump_page_lvl()?
> > >
> > > I am sorry, I remembered incorrectly, we are getting reference right
> > > after dump_page_lvl() in page_detective_memcg() -> folio_try_get(); I
> > > will move the folio_try_get() to before dump_page_lvl().
> > >
> > > > > > So I think dump_page() in its current form is not something we =
should
> > > > > > expose to a userspace-reachable API.
> > > > >
> > > > > We use dump_page() all over WARN_ONs in MM code where pages might=
 not
> > > > > be locked, but this is a good point, that while even the existing
> > > > > usage might be racy, providing a user-reachable API potentially m=
akes
> > > > > it worse. I will see if I could add some locking before dump_page=
(),
> > > > > or make a dump_page variant that does not do dump_mapping().
> > > >
> > > > To be clear, I am not that strongly opposed to racily reading data
> > > > such that the data may not be internally consistent or such; but th=
is
> > > > is a case of racy use-after-free reads that might end up dumping
> > > > entirely unrelated memory contents into dmesg. I think we should
> > > > properly protect against that in an API that userspace can invoke.
> > > > Otherwise, if we race, we might end up writing random memory conten=
ts
> > > > into dmesg; and if we are particularly unlucky, those random memory
> > > > contents could be PII or authentication tokens or such.
> > > >
> > > > I'm not entirely sure what the right approach is here; I guess it
> > > > makes sense that when the kernel internally detects corruption,
> > > > dump_page doesn't take references on pages it accesses to avoid
> > > > corrupting things further. If you are looking at a page based on a
> > > > userspace request, I guess you could access the page with the
> > > > necessary locking to access its properties under the normal locking
> > > > rules?
> > >
> > > I will take reference, as we already do that for memcg purpose, but
> > > have not included dump_page().
> >
> > Note that taking a reference on the page does not make all of
> > dump_page() fine; in particular, my understanding is that
> > folio_mapping() requires that the page is locked in order to return a
> > stable pointer, and some of the code in dump_mapping() would probably
> > also require some other locks - probably at least on the inode and
> > maybe also on the dentry, I think? Otherwise the inode's dentry list
> > can probably change concurrently, and the dentry's name pointer can
> > change too.
>
> Agreed, once reference is taken, the page identity cannot change (i.e.
> if it is a named page it will stay a named page), but dentry can be
> renamed. I will look into what can be done to guarantee consistency in
> the next version. There is also a fallback if locking cannot be
> reliably resolved (i.e. for performance reasons) where we can make
> dump_mapping() optionally disabled from dump_page_lvl() with a new
> argument flag.

Yeah, I think if you don't need the details that dump_mapping() shows,
skipping that for user-requested dumps might be a reasonable option.

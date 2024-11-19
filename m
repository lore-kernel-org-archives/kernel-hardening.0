Return-Path: <kernel-hardening-return-21861-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 054D9D44167
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2024 15:15:11 +0000 (UTC)
Received: (qmail 19938 invoked by uid 550); 19 Nov 2024 15:14:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19902 invoked from network); 19 Nov 2024 15:14:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1732029290; x=1732634090; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHwDnKru70pWnl/9WBuQ20Iik4fo0kZl81qP2ypGaJI=;
        b=MV/QRtjLkDAJ9sBTP0S16HeRMfkz6MUsFFrCsB7tmvx/e8zgIw9O4W9WIJUV6/Sadv
         605QQ2AXynCCXF2tXc10v92HKhPIdzLFiBnC45IqlRM1aODE6LmzZBGGwRCSQAG6/sJC
         UzIT1Kd/Ap0iFQ34TIDxXE5H4lTdRYRHe7jfeg+0DPlygvYoYqSZJI8efyeIBtpqk6Us
         Bg/IIO+3uAcsohH/qveXsBw2YMiKQVLZun6WN7bly5RPvmrF8qkFKEteJ2qPcib82OSK
         TLShhT/qmo38vqNZwvCY967ZLIgFMlvlhmN73dbavEGE6UJT+KE1GVg6C72k3XFyDjMo
         k6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732029290; x=1732634090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RHwDnKru70pWnl/9WBuQ20Iik4fo0kZl81qP2ypGaJI=;
        b=Qi+9f3gVTruOPESR01lP+0bfM0ruVq+WTX3dqdl4EbJtFNUxEybrBQCL4CXkMT7Vs1
         6NCZZ5eIO26no9g1Jh2hK+dvS0IY4aENe6nspYQcq52yU9HyjGhKhHFQ+5fM2awR8tUI
         uhNnwN53WKjf7GCA2BvEGGLtpST9zeWxGi028Y/tWXugchjfRO5xjFZznhAQIKbDCsCz
         ccYyBKHfxYtiUI48ZkZtGHpA+XFGLsyb34/qUt5NuBPyWubHLZLux0DWHdZoW6himen7
         YnkL1KICE8s6LyYorWGLPp1c2VqYRBMFbPxLILl5xOdaES8kN8i3YMV9mmlEXlJhUytm
         vPeA==
X-Forwarded-Encrypted: i=1; AJvYcCV70xsEQ3EjL4T6DT1dJs8HDbmVhDSLje+yrhjxFZJQq2750x+q+N3SCt3UIhwBD7K2gqsQUC8qY8Nhg6JBIPz5@lists.openwall.com
X-Gm-Message-State: AOJu0Yxq4II2mVtY4a6NXtQHFpC/Y3juWSunU8dMZYoi/+NWSF74/weP
	AggqBChW1+CglNlDzyUmSa8TxwQfpvXaWsLX8KSBPjPkLE6BANeYdt33j2xwKdpZbLjyzYczFCw
	dbj5/OZgfjVmy8uUQ5xoNMOZ2s2EdYbjCE5kzzw==
X-Google-Smtp-Source: AGHT+IEJwBZlUovcinMC2W5fFA797qZwYwLBmxYXTBNzEM0XjyLH7M5le4TEh6FQXiXxZ5fybascQvNQ8dVlyHK3oWk=
X-Received: by 2002:a05:622a:1b06:b0:462:b856:c8fe with SMTP id
 d75a77b69052e-46392d511bcmr58315681cf.1.1732029290306; Tue, 19 Nov 2024
 07:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com>
 <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local> <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
 <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com>
 <CAG48ez1KFFXzy5qcYVZLnUEztaZxDGY2+4GvwYq7Hb=Y=3FBxQ@mail.gmail.com>
 <CA+CK2bCBwZFomepG-Pp6oiAwHQiKdsTLe3rYtE3hFSQ5spEDww@mail.gmail.com> <CAG48ez0NzMbwnbvMO7KbUROZq5ne7fhiau49v7oyxwPrYL=P6Q@mail.gmail.com>
In-Reply-To: <CAG48ez0NzMbwnbvMO7KbUROZq5ne7fhiau49v7oyxwPrYL=P6Q@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 19 Nov 2024 10:14:12 -0500
Message-ID: <CA+CK2bByXtm8sLyFzDDzm5xC6xb=DEutaRUeujGJdwf-kmK1gA@mail.gmail.com>
Subject: Re: [RFCv1 0/6] Page Detective
To: Jann Horn <jannh@google.com>
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

On Tue, Nov 19, 2024 at 7:52=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Tue, Nov 19, 2024 at 2:30=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> > > Can you point me to where a refcounted reference to the page comes
> > > from when page_detective_metadata() calls dump_page_lvl()?
> >
> > I am sorry, I remembered incorrectly, we are getting reference right
> > after dump_page_lvl() in page_detective_memcg() -> folio_try_get(); I
> > will move the folio_try_get() to before dump_page_lvl().
> >
> > > > > So I think dump_page() in its current form is not something we sh=
ould
> > > > > expose to a userspace-reachable API.
> > > >
> > > > We use dump_page() all over WARN_ONs in MM code where pages might n=
ot
> > > > be locked, but this is a good point, that while even the existing
> > > > usage might be racy, providing a user-reachable API potentially mak=
es
> > > > it worse. I will see if I could add some locking before dump_page()=
,
> > > > or make a dump_page variant that does not do dump_mapping().
> > >
> > > To be clear, I am not that strongly opposed to racily reading data
> > > such that the data may not be internally consistent or such; but this
> > > is a case of racy use-after-free reads that might end up dumping
> > > entirely unrelated memory contents into dmesg. I think we should
> > > properly protect against that in an API that userspace can invoke.
> > > Otherwise, if we race, we might end up writing random memory contents
> > > into dmesg; and if we are particularly unlucky, those random memory
> > > contents could be PII or authentication tokens or such.
> > >
> > > I'm not entirely sure what the right approach is here; I guess it
> > > makes sense that when the kernel internally detects corruption,
> > > dump_page doesn't take references on pages it accesses to avoid
> > > corrupting things further. If you are looking at a page based on a
> > > userspace request, I guess you could access the page with the
> > > necessary locking to access its properties under the normal locking
> > > rules?
> >
> > I will take reference, as we already do that for memcg purpose, but
> > have not included dump_page().
>
> Note that taking a reference on the page does not make all of
> dump_page() fine; in particular, my understanding is that
> folio_mapping() requires that the page is locked in order to return a
> stable pointer, and some of the code in dump_mapping() would probably
> also require some other locks - probably at least on the inode and
> maybe also on the dentry, I think? Otherwise the inode's dentry list
> can probably change concurrently, and the dentry's name pointer can
> change too.

Agreed, once reference is taken, the page identity cannot change (i.e.
if it is a named page it will stay a named page), but dentry can be
renamed. I will look into what can be done to guarantee consistency in
the next version. There is also a fallback if locking cannot be
reliably resolved (i.e. for performance reasons) where we can make
dump_mapping() optionally disabled from dump_page_lvl() with a new
argument flag.

Thank you,
Pasha

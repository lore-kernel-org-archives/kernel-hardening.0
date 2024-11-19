Return-Path: <kernel-hardening-return-21860-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9845DD44155
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2024 12:52:59 +0000 (UTC)
Received: (qmail 3464 invoked by uid 550); 19 Nov 2024 12:52:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3444 invoked from network); 19 Nov 2024 12:52:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732020758; x=1732625558; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRauzgQtwAabGE/huRKr8PjySPrqwLknQlRBGuzARcE=;
        b=UhUTlDo2/1GP00ZbFNKMWikqJGrjE28N6M4GRpVfWC1udHD/fyR1Xxvc/bFQSzZXFE
         kfK4gPTIsWn8tttxMbh0wRXXokyplf0rPEOzxGBU9jOB8d+y72hsuR0YtLr79HYYeh+j
         G9eVoF/svzfVYOLCHur6/sn0HIkmJ78DSQ5bLTWqdIJlm+OT7wzzLu3QV/cQvvN486dp
         qzu50KU1lvV/fmJ7wM4+X6SdpAN+XPbGyTyKzWMJOjQ1Wyedx1KpswzQu0v9T/ITYixh
         7PZPQKpNZAI1ekP9d0TeJ/FTkghhdfQzyRgpmQLt5Km9E/mwvrygtrx9kTOLJbl9APA6
         /xDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732020758; x=1732625558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRauzgQtwAabGE/huRKr8PjySPrqwLknQlRBGuzARcE=;
        b=hLBjcUKXuRZzzYMGCeI5z2SxdcG/Roe8LaqTxLh5pKYCXgB8cXZbpekte2BzIqMSly
         /Coc6Tk4YgFE2VtXhfjDT++ySeFU7grTKRWPk/KNyLHIMj8p+pfwUsByX8XtHdMROVnB
         ureomokzErXuP79rmGrvI9bWY4ZAMgz1R3maupeBFyivGwvm1W8+v6JYCg7Q/OoxGxwW
         Ewj/3du6/QMilajZfSbSwN3aiC56CYrbz7ktoW3+Tf1DEbzhd1GXS0hDNeV9XuAaYr3J
         cFNlRd/Zl4wJV0ek0IRGKQZQneCrHYkRxc79WrCAC/zxD03b7PYHnmzASIswxttB4uNU
         u9ag==
X-Forwarded-Encrypted: i=1; AJvYcCXIaIbx/A3I9WjEWndIKbMS/8KOgP9lNBi/0jKBK50lAxq07PFAPS6fE1VRdVQlboqBHYLdWPxW453CpXzWyNnc@lists.openwall.com
X-Gm-Message-State: AOJu0YynVmM+rOXYd2kF8tXfo1WyyBOOqEkjg3PUMqojPd+x2ozZcUAf
	2R0kU6dMBwQx1imIvuNTu/Fvh5/B+5iv03d/eTX5RPrBpaH8R8VbCyHHvUPRDB03kYpK6q+6qI5
	olzUZFNttTRcrpMvNwQLRlxrpYmILP6zyDD1f
X-Gm-Gg: ASbGnctiI9fYxPTa4p6Hkb7Qnlnz189QlQfqd6g5MBQTxkvLe3hIOTt0YOKvDtg7+zY
	9sSTfVn4+7SeRwSzDy50WXzRv3JbWHpsTZS7rmPIofjSOXWBNOv/WbSjReyc=
X-Google-Smtp-Source: AGHT+IHrO5qfRHSlmQCwNzrJObJ8F+5vL3isZu6sEndbtNy8+TOZx/SUWI/RHP6UiYngvZBnewRWzZBX4xLAvWC6WJw=
X-Received: by 2002:a05:6402:1351:b0:5cf:bd9a:41ec with SMTP id
 4fb4d7f45d1cf-5cfdec244d3mr70875a12.2.1732020757739; Tue, 19 Nov 2024
 04:52:37 -0800 (PST)
MIME-Version: 1.0
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com>
 <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local> <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
 <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com>
 <CAG48ez1KFFXzy5qcYVZLnUEztaZxDGY2+4GvwYq7Hb=Y=3FBxQ@mail.gmail.com> <CA+CK2bCBwZFomepG-Pp6oiAwHQiKdsTLe3rYtE3hFSQ5spEDww@mail.gmail.com>
In-Reply-To: <CA+CK2bCBwZFomepG-Pp6oiAwHQiKdsTLe3rYtE3hFSQ5spEDww@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 Nov 2024 13:52:00 +0100
Message-ID: <CAG48ez0NzMbwnbvMO7KbUROZq5ne7fhiau49v7oyxwPrYL=P6Q@mail.gmail.com>
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

On Tue, Nov 19, 2024 at 2:30=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
> > Can you point me to where a refcounted reference to the page comes
> > from when page_detective_metadata() calls dump_page_lvl()?
>
> I am sorry, I remembered incorrectly, we are getting reference right
> after dump_page_lvl() in page_detective_memcg() -> folio_try_get(); I
> will move the folio_try_get() to before dump_page_lvl().
>
> > > > So I think dump_page() in its current form is not something we shou=
ld
> > > > expose to a userspace-reachable API.
> > >
> > > We use dump_page() all over WARN_ONs in MM code where pages might not
> > > be locked, but this is a good point, that while even the existing
> > > usage might be racy, providing a user-reachable API potentially makes
> > > it worse. I will see if I could add some locking before dump_page(),
> > > or make a dump_page variant that does not do dump_mapping().
> >
> > To be clear, I am not that strongly opposed to racily reading data
> > such that the data may not be internally consistent or such; but this
> > is a case of racy use-after-free reads that might end up dumping
> > entirely unrelated memory contents into dmesg. I think we should
> > properly protect against that in an API that userspace can invoke.
> > Otherwise, if we race, we might end up writing random memory contents
> > into dmesg; and if we are particularly unlucky, those random memory
> > contents could be PII or authentication tokens or such.
> >
> > I'm not entirely sure what the right approach is here; I guess it
> > makes sense that when the kernel internally detects corruption,
> > dump_page doesn't take references on pages it accesses to avoid
> > corrupting things further. If you are looking at a page based on a
> > userspace request, I guess you could access the page with the
> > necessary locking to access its properties under the normal locking
> > rules?
>
> I will take reference, as we already do that for memcg purpose, but
> have not included dump_page().

Note that taking a reference on the page does not make all of
dump_page() fine; in particular, my understanding is that
folio_mapping() requires that the page is locked in order to return a
stable pointer, and some of the code in dump_mapping() would probably
also require some other locks - probably at least on the inode and
maybe also on the dentry, I think? Otherwise the inode's dentry list
can probably change concurrently, and the dentry's name pointer can
change too.

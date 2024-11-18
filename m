Return-Path: <kernel-hardening-return-21857-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 84240D60CF8
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 Nov 2024 22:33:58 +0000 (UTC)
Received: (qmail 17466 invoked by uid 550); 18 Nov 2024 22:33:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5437 invoked from network); 18 Nov 2024 22:24:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1731968679; x=1732573479; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mr6iDGZX6WZlOIa/AqtWy4H1dbsMF9ugeMcnS6HxJNE=;
        b=BXlJhPAI4vF7PBgH3ia1uL300r6q/v7HKSHD9mRDyaeI65Onj+sERAkHJCIGfhQgeN
         v4/MuGjwGrR3lBdEAPoNkIgfbAaKtt8pu1rEiBJyELz95E+W1RK4vpofkzGZhrKxFxYT
         4ZmumKJvQKzb/rtx+E0LscAtCw54GCYF6GETZIvNvtGf57aGsRGyMN7RLqyKYyKLnkSR
         AwCyktQ3OGOodHlMehXSrxExWH5NcuWQW2DfFdbdSo5mDWvMtGJVoeDybdbP0iAFIjCR
         BxSqMvXukoHJrY63XGzjLP689S5mXZQ9Zpv0ZIV4wUB3PI/HTipSdhoExAvKzd9Sdl7i
         uQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731968679; x=1732573479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mr6iDGZX6WZlOIa/AqtWy4H1dbsMF9ugeMcnS6HxJNE=;
        b=wbkpuofhcTXgf98+5W7rGWedj4xtAXX68zubxVQZkxEIMDoC0qJq5P0J36ds/+7qmc
         k4oo8IYmiVHaqnGn+840lVsG0CeQQS5FkABs1d6Wzx884eK4k13P6VgONOO3AAUdDuB6
         EqLX93fBnxmUFOKyldgPe/46ChxFyz6WW/B2nZ+YF9i8jZLK0XCqpaEObpC544n2LzSc
         hYRYYLVkTXeiZwLs/L68xP8v64lyd/gmPT17ESdZGsOJxiNQQkZ2zDgoFaDYkW6x5Zye
         gcPliydF43HcB0Nf6Uclp53AmF8McHVV7NJjFvpdO6BGEUpEWblJwsAiMvqu4oduFI/p
         umRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeRroCAJqhyFIJX9EaRmKXCuYJJolWoqegGsmGHJ3sydOcuI45VPpYeC6y6liFj5MDdyeiWEaJWJQW/HqOCbYC@lists.openwall.com
X-Gm-Message-State: AOJu0YxRsx0xAGCsngXICPUljhK4VD5Ypl/B75kN42tHnW9gz6hN7P//
	McSW/kHSQZGqUt3fVF2QuNuSzArIFzBiridkW+5owvlgeKjPS6ebpPqODBryZ+cJdvS4WK4spQ9
	8lGYrZvU5vc1ItmVNaxqzRjmAlbbToJc3cvRsKw==
X-Google-Smtp-Source: AGHT+IFJn12BEIzoEKgSqnP8cIUM9l+AVMCmmrovlugeE4ncddPOm9spXZtngGYQPZw7li3y2om6vXnU1SKoOL9vTX0=
X-Received: by 2002:ac8:45c8:0:b0:463:788e:7912 with SMTP id
 d75a77b69052e-463788e81b9mr128943351cf.56.1731968679432; Mon, 18 Nov 2024
 14:24:39 -0800 (PST)
MIME-Version: 1.0
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com>
 <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local> <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
In-Reply-To: <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 18 Nov 2024 17:24:02 -0500
Message-ID: <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com>
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

On Mon, Nov 18, 2024 at 7:54=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Nov 18, 2024 at 12:17=E2=80=AFPM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Sat, Nov 16, 2024 at 05:59:16PM +0000, Pasha Tatashin wrote:
> > > It operates through the Linux debugfs interface, with two files: "vir=
t"
> > > and "phys".
> > >
> > > The "virt" file takes a virtual address and PID and outputs informati=
on
> > > about the corresponding page.
> > >
> > > The "phys" file takes a physical address and outputs information abou=
t
> > > that page.
> > >
> > > The output is presented via kernel log messages (can be accessed with
> > > dmesg), and includes information such as the page's reference count,
> > > mapping, flags, and memory cgroup. It also shows whether the page is
> > > mapped in the kernel page table, and if so, how many times.
> >
> > I mean, even though I'm not a huge fan of kernel pointer hashing etc. t=
his
> > is obviously leaking as much information as you might want about kernel
> > internal state to the point of maybe making the whole kernel pointer
> > hashing thing moot.
> >
> > I know this requires CAP_SYS_ADMIN, but there are things that also requ=
ire
> > that which _still_ obscure kernel pointers.
> >
> > And you're outputting it all to dmesg.
> >
> > So yeah, a security person (Jann?) would be better placed to comment on
> > this than me, but are we sure we want to do this when not in a
> > CONFIG_DEBUG_VM* kernel?
>
> I guess there are two parts to this - what root is allowed to do, and
> what information we're fine with exposing to dmesg.
>
> If the lockdown LSM is not set to LOCKDOWN_CONFIDENTIALITY_MAX, the
> kernel allows root to read kernel memory through some interfaces - in
> particular, BPF allows reading arbitrary kernel memory, and perf
> allows reading at least some stuff (like kernel register states). With
> lockdown in the most restrictive mode, the kernel tries to prevent
> root from reading arbitrary kernel memory, but we don't really change
> how much information goes into dmesg. (And I imagine you could
> probably still get kernel pointers out of BPF somehow even in the most
> restrictive lockdown mode, but that's probably not relevant.)
>
> The main issue with dmesg is that some systems make its contents
> available to code that is not running with root privileges; and I
> think it is also sometimes stored persistently in unencrypted form
> (like in EFI pstore) even when everything else on the system is
> encrypted.
> So on one hand, we definitely shouldn't print the contents of random
> chunks of memory into dmesg without a good reason; on the other hand,
> for example we do already print kernel register state on WARN() (which
> often includes kernel pointers and could theoretically include more
> sensitive data too).
>
> So I think showing page metadata to root when requested is probably
> okay as a tradeoff? And dumping that data into dmesg is maybe not
> great, but acceptable as long as only root can actually trigger this?
>
> I don't really have a strong opinion on this...
>
>
> To me, a bigger issue is that dump_page() looks like it might be racy,
> which is maybe not terrible in debugging code that only runs when
> something has already gone wrong, but bad if it is in code that root
> can trigger on demand?

Hi Jann, thank you for reviewing this proposal.

Presumably, the interface should be used only when something has gone
wrong but has not been noticed by the kernel. That something is
usually checksums failures that are outside of the kernel: i.e. during
live migration, snapshotting, filesystem journaling, etc. We already
have interfaces that provide data from the live kernel that could be
racy, i.e. crash utility.

> __dump_page() copies the given page with
> memcpy(), which I don't think guarantees enough atomicity with
> concurrent updates of page->mapping or such, so dump_mapping() could
> probably run on a bogus pointer. Even without torn pointers, I think
> there could be a UAF if the page's mapping is destroyed while we're
> going through dump_page(), since the page might not be locked. And in
> dump_mapping(), the strncpy_from_kernel_nofault() also doesn't guard
> against concurrent renaming of the dentry, which I think again would
> probably result in UAF.

Since we are holding a reference on the page at the time of
dump_page(), the identity of the page should not really change, but
dentry can be renamed.

> So I think dump_page() in its current form is not something we should
> expose to a userspace-reachable API.

We use dump_page() all over WARN_ONs in MM code where pages might not
be locked, but this is a good point, that while even the existing
usage might be racy, providing a user-reachable API potentially makes
it worse. I will see if I could add some locking before dump_page(),
or make a dump_page variant that does not do dump_mapping().

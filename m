Return-Path: <kernel-hardening-return-21858-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AF178D60D00
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2024 00:40:19 +0000 (UTC)
Received: (qmail 3341 invoked by uid 550); 19 Nov 2024 00:40:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3320 invoked from network); 19 Nov 2024 00:40:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731976797; x=1732581597; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzMNvJAMgAye6FGH0t0zMVzWqRVdNrG+1sIZy8+p89A=;
        b=S9ckrUlo+kvtpEbdbNgdX3d6P4HNrX5a8EANg4MrGgUpNcFFUlW+2oNQzY4tVVSsPq
         mZfX8i6A+dZRxYli6buVSUthTG+miLQNb/uLEUaxqW/1SVF2DxSLvYLDhPVx7BknPRHl
         rf/H+Y05yE4NbXRSeMzSXV1sasE+SHwjUFgDo7hFENh0aLH2LJS6Pjm0c4T2GSpHAwj/
         D9hyiEMDoCae0EewPx4RGUwSUWu4s/sMIDaPgMTZ0UY/VkKs0fbyLw9uXconSSAhTgdP
         Df0jEMJ++E3demi7IbrYTBstuunl5cRextZzPtVj5qkadg408RoOFRy2eOf9laLMWi39
         1tSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731976797; x=1732581597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzMNvJAMgAye6FGH0t0zMVzWqRVdNrG+1sIZy8+p89A=;
        b=n2EIQaN3VFyUnvNRyyiSN08qeHRF40YB5oBsZSrxOCea/OsfxLyq2Ua89Z/2M7EJ2v
         3K+IjtbEZz5GOFEvgw4uGMlL5q9hGXYKMGQAJm8rFR0uhgO5vHDdo91oHKpqTjwzoySt
         S8q7hk6OjBGSzPtD/bjZ5gCRqROZwyG43afl8oJM3CCGdOjCerCupO1ZysGT6hZcXGWL
         VVdhMv7AXpOQZw9aSuCQN0Vf6oV9CQKQWaFyYPT/RxgBVYtEsLem3wCOiKB88vDAUeuH
         638aQZvCuYrNPfW9dyERNt9prGe4/wAiB3ZxW1sWa9x+LKA2lANm/IDY7gOQM9o+xQr2
         nTAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0veADgfMyN+geuH4T32RaGt6hWvg+kBmWs/sHldt2kIF/pKdG2uDbX3st+Wh6pOL9R57sFb+/vkEZB9f04AbK@lists.openwall.com
X-Gm-Message-State: AOJu0YxeGsGddy9AcNJhQ9My2j1YocE901uD/ovBXvguWnr6jIv2Kx9d
	GfkeFnlwrQ16zjzHhcaG6iuCZ3gjfL4mOdbZCSdKg+xdPBwyUPaxtfgUMnI4r6CVv2UkbOTCTO4
	JWWACn40orIJ1OGPOO2X5267GPHDQnFGGOQwX
X-Gm-Gg: ASbGncvfLxlJt1GzV9ECMlUvosm9jtxB45mMgj1jbsrSMzNKY316hzubLUKiRb/zQ5w
	PVxf/wvoC4ArUi+BH4K3X8Dmg2dkBExEmRZrlOWW3PzHtgd5U5pzb2opicp0G
X-Google-Smtp-Source: AGHT+IEqFrrGyfsezRMsp/X151aTE55F7rPkKrYZLMq7HZJ1MQF2NOGKpWL8huBQFIpX81LUzRGmY7/k9ZOF+cLi7qc=
X-Received: by 2002:a05:6402:1351:b0:5cf:bd9a:41ec with SMTP id
 4fb4d7f45d1cf-5cfdec244d3mr32883a12.2.1731976796952; Mon, 18 Nov 2024
 16:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com>
 <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local> <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
 <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com>
In-Reply-To: <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 Nov 2024 01:39:19 +0100
Message-ID: <CAG48ez1KFFXzy5qcYVZLnUEztaZxDGY2+4GvwYq7Hb=Y=3FBxQ@mail.gmail.com>
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

On Mon, Nov 18, 2024 at 11:24=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
> On Mon, Nov 18, 2024 at 7:54=E2=80=AFAM Jann Horn <jannh@google.com> wrot=
e:
> >
> > On Mon, Nov 18, 2024 at 12:17=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Sat, Nov 16, 2024 at 05:59:16PM +0000, Pasha Tatashin wrote:
> > > > It operates through the Linux debugfs interface, with two files: "v=
irt"
> > > > and "phys".
> > > >
> > > > The "virt" file takes a virtual address and PID and outputs informa=
tion
> > > > about the corresponding page.
> > > >
> > > > The "phys" file takes a physical address and outputs information ab=
out
> > > > that page.
> > > >
> > > > The output is presented via kernel log messages (can be accessed wi=
th
> > > > dmesg), and includes information such as the page's reference count=
,
> > > > mapping, flags, and memory cgroup. It also shows whether the page i=
s
> > > > mapped in the kernel page table, and if so, how many times.
> > >
> > > I mean, even though I'm not a huge fan of kernel pointer hashing etc.=
 this
> > > is obviously leaking as much information as you might want about kern=
el
> > > internal state to the point of maybe making the whole kernel pointer
> > > hashing thing moot.
> > >
> > > I know this requires CAP_SYS_ADMIN, but there are things that also re=
quire
> > > that which _still_ obscure kernel pointers.
> > >
> > > And you're outputting it all to dmesg.
> > >
> > > So yeah, a security person (Jann?) would be better placed to comment =
on
> > > this than me, but are we sure we want to do this when not in a
> > > CONFIG_DEBUG_VM* kernel?
> >
> > I guess there are two parts to this - what root is allowed to do, and
> > what information we're fine with exposing to dmesg.
> >
> > If the lockdown LSM is not set to LOCKDOWN_CONFIDENTIALITY_MAX, the
> > kernel allows root to read kernel memory through some interfaces - in
> > particular, BPF allows reading arbitrary kernel memory, and perf
> > allows reading at least some stuff (like kernel register states). With
> > lockdown in the most restrictive mode, the kernel tries to prevent
> > root from reading arbitrary kernel memory, but we don't really change
> > how much information goes into dmesg. (And I imagine you could
> > probably still get kernel pointers out of BPF somehow even in the most
> > restrictive lockdown mode, but that's probably not relevant.)
> >
> > The main issue with dmesg is that some systems make its contents
> > available to code that is not running with root privileges; and I
> > think it is also sometimes stored persistently in unencrypted form
> > (like in EFI pstore) even when everything else on the system is
> > encrypted.
> > So on one hand, we definitely shouldn't print the contents of random
> > chunks of memory into dmesg without a good reason; on the other hand,
> > for example we do already print kernel register state on WARN() (which
> > often includes kernel pointers and could theoretically include more
> > sensitive data too).
> >
> > So I think showing page metadata to root when requested is probably
> > okay as a tradeoff? And dumping that data into dmesg is maybe not
> > great, but acceptable as long as only root can actually trigger this?
> >
> > I don't really have a strong opinion on this...
> >
> >
> > To me, a bigger issue is that dump_page() looks like it might be racy,
> > which is maybe not terrible in debugging code that only runs when
> > something has already gone wrong, but bad if it is in code that root
> > can trigger on demand?
>
> Hi Jann, thank you for reviewing this proposal.
>
> Presumably, the interface should be used only when something has gone
> wrong but has not been noticed by the kernel. That something is
> usually checksums failures that are outside of the kernel: i.e. during
> live migration, snapshotting, filesystem journaling, etc. We already
> have interfaces that provide data from the live kernel that could be
> racy, i.e. crash utility.

Ah, yes, I'm drawing a distinction here between "something has gone
wrong internally in the kernel and the kernel does some kinda-broken
best-effort self-diagnostics" and "userspace thinks something is
broken and asks the kernel".

> > __dump_page() copies the given page with
> > memcpy(), which I don't think guarantees enough atomicity with
> > concurrent updates of page->mapping or such, so dump_mapping() could
> > probably run on a bogus pointer. Even without torn pointers, I think
> > there could be a UAF if the page's mapping is destroyed while we're
> > going through dump_page(), since the page might not be locked. And in
> > dump_mapping(), the strncpy_from_kernel_nofault() also doesn't guard
> > against concurrent renaming of the dentry, which I think again would
> > probably result in UAF.
>
> Since we are holding a reference on the page at the time of
> dump_page(), the identity of the page should not really change, but
> dentry can be renamed.

Can you point me to where a refcounted reference to the page comes
from when page_detective_metadata() calls dump_page_lvl()?

> > So I think dump_page() in its current form is not something we should
> > expose to a userspace-reachable API.
>
> We use dump_page() all over WARN_ONs in MM code where pages might not
> be locked, but this is a good point, that while even the existing
> usage might be racy, providing a user-reachable API potentially makes
> it worse. I will see if I could add some locking before dump_page(),
> or make a dump_page variant that does not do dump_mapping().

To be clear, I am not that strongly opposed to racily reading data
such that the data may not be internally consistent or such; but this
is a case of racy use-after-free reads that might end up dumping
entirely unrelated memory contents into dmesg. I think we should
properly protect against that in an API that userspace can invoke.
Otherwise, if we race, we might end up writing random memory contents
into dmesg; and if we are particularly unlucky, those random memory
contents could be PII or authentication tokens or such.

I'm not entirely sure what the right approach is here; I guess it
makes sense that when the kernel internally detects corruption,
dump_page doesn't take references on pages it accesses to avoid
corrupting things further. If you are looking at a page based on a
userspace request, I guess you could access the page with the
necessary locking to access its properties under the normal locking
rules?

(If anyone else has opinions either way on this line I'm trying to
draw between kernel-internal debug paths and userspace-triggerable
debugging, feel free to share; I hope my mental model makes sense but
I could imagine other folks having a different model of this?)

Return-Path: <kernel-hardening-return-21856-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9D6E6D49219
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 Nov 2024 12:54:45 +0000 (UTC)
Received: (qmail 29877 invoked by uid 550); 18 Nov 2024 12:54:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29853 invoked from network); 18 Nov 2024 12:54:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731934464; x=1732539264; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RFZav5imPpDajhAmqlY2eOGgnED4NjQI6+JJoDQ71N0=;
        b=F3SKr4Db5O4efvPwZ6KFGC1491r2XwDID2saZsM2gZe7w1QpOp8Jivyr1c8umEV1ZB
         bzDgUjh+MJcQhKrHmFJ8/ZcmbjXpwi3ce/KfHfskthu8VchY1zlxW2n4uG97SDA5H73a
         lOC2fJ1uZDei2WBT0M/hY8LXJTOqbgjWntde+DvOMpaXVd7zAJwovVtYG/VtU/RZ/wPv
         PY+2gzuVsJKvfM82rzWwnLV3r8yqThL+PILp7c/MoHdGWW7n2jZt8ieiesQSjyjGTyE3
         YlUbRZrrJS+PNPokQbylsCuYbECsXyyD5QN5eYL3083sCqYELsoVDi4o4lIqzSisfm/q
         u7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731934464; x=1732539264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RFZav5imPpDajhAmqlY2eOGgnED4NjQI6+JJoDQ71N0=;
        b=HqqaWXScPlfF7UO3JZ68praKnAlKnldNMSJ4rIacUxvw2a3VhTvah0Xrsyl6pAIwzl
         2LPc6UEmpiZBYKv/+sgxaADDzr4GpZRkn3MAyh379P+//B4bS5wL2+QvDiotfzbE31I9
         grk4ghpnbCp1ZgwkKTmTraxQulF0b771JRpf0IsrUZ2Cu+6hUdNs6I7p4hKK0t4EHfD4
         URF3uLFRvbr1ClAig1F2BvcUSnTcfqRXM4ZoZUfmTaqyomR0QghGAIeuiozYpXb4w+0D
         sVSRVb7BeVtjmG628Ndtj+H4kYWy+lfgUSjTM5hxzUcl17w3nNwpG+uywW/Jw2ic6QGM
         i8Fw==
X-Forwarded-Encrypted: i=1; AJvYcCVt99f7Wq15RajPDAghXkaOKC8A697Z14U+AyeGq4B7iWRDNh5ZrhA7mydI5XLbBQnx3ScbTuwRacSDmKRy5mhs@lists.openwall.com
X-Gm-Message-State: AOJu0Yw0ILZjQi6JK0tfcT/2FxA9B3Kp4c6Mc7JZFkCmqcy35KqYqkZ7
	5ugwWJIxqny6rEN/REd+mJqZTU5946PChz/S3tFy71rHLR/D99HP2VXuAV/U78eF26rBSFv/sYV
	xI6vAonBS3YNtPULPgY5AIOb61MZVcsBeOx+d
X-Gm-Gg: ASbGncsLgF/jj2gnYuwHX8f1JGZKZxSKmumcDYw3RRNS6IU9PeK9KTUXnSjkr77eS1Q
	vkI+ZNZpBosJc7XVNcFrQ3mDA6uDRfMREOMXVkFk9gM1u89rmDb5Ln0RckAE=
X-Google-Smtp-Source: AGHT+IFWl9n8jfw906nl94a7cbMwHIP9Gd4TNcFZWOOm8Tvrj69mcd0XEdLXVwoqv6yIo+K1feYbwLqCVdza/E5/6V8=
X-Received: by 2002:aa7:de84:0:b0:5cf:6f4d:c29c with SMTP id
 4fb4d7f45d1cf-5cfa298afd6mr136645a12.4.1731934463854; Mon, 18 Nov 2024
 04:54:23 -0800 (PST)
MIME-Version: 1.0
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com> <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local>
In-Reply-To: <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Mon, 18 Nov 2024 13:53:46 +0100
Message-ID: <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
Subject: Re: [RFCv1 0/6] Page Detective
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
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

On Mon, Nov 18, 2024 at 12:17=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Sat, Nov 16, 2024 at 05:59:16PM +0000, Pasha Tatashin wrote:
> > It operates through the Linux debugfs interface, with two files: "virt"
> > and "phys".
> >
> > The "virt" file takes a virtual address and PID and outputs information
> > about the corresponding page.
> >
> > The "phys" file takes a physical address and outputs information about
> > that page.
> >
> > The output is presented via kernel log messages (can be accessed with
> > dmesg), and includes information such as the page's reference count,
> > mapping, flags, and memory cgroup. It also shows whether the page is
> > mapped in the kernel page table, and if so, how many times.
>
> I mean, even though I'm not a huge fan of kernel pointer hashing etc. thi=
s
> is obviously leaking as much information as you might want about kernel
> internal state to the point of maybe making the whole kernel pointer
> hashing thing moot.
>
> I know this requires CAP_SYS_ADMIN, but there are things that also requir=
e
> that which _still_ obscure kernel pointers.
>
> And you're outputting it all to dmesg.
>
> So yeah, a security person (Jann?) would be better placed to comment on
> this than me, but are we sure we want to do this when not in a
> CONFIG_DEBUG_VM* kernel?

I guess there are two parts to this - what root is allowed to do, and
what information we're fine with exposing to dmesg.

If the lockdown LSM is not set to LOCKDOWN_CONFIDENTIALITY_MAX, the
kernel allows root to read kernel memory through some interfaces - in
particular, BPF allows reading arbitrary kernel memory, and perf
allows reading at least some stuff (like kernel register states). With
lockdown in the most restrictive mode, the kernel tries to prevent
root from reading arbitrary kernel memory, but we don't really change
how much information goes into dmesg. (And I imagine you could
probably still get kernel pointers out of BPF somehow even in the most
restrictive lockdown mode, but that's probably not relevant.)

The main issue with dmesg is that some systems make its contents
available to code that is not running with root privileges; and I
think it is also sometimes stored persistently in unencrypted form
(like in EFI pstore) even when everything else on the system is
encrypted.
So on one hand, we definitely shouldn't print the contents of random
chunks of memory into dmesg without a good reason; on the other hand,
for example we do already print kernel register state on WARN() (which
often includes kernel pointers and could theoretically include more
sensitive data too).

So I think showing page metadata to root when requested is probably
okay as a tradeoff? And dumping that data into dmesg is maybe not
great, but acceptable as long as only root can actually trigger this?

I don't really have a strong opinion on this...


To me, a bigger issue is that dump_page() looks like it might be racy,
which is maybe not terrible in debugging code that only runs when
something has already gone wrong, but bad if it is in code that root
can trigger on demand? __dump_page() copies the given page with
memcpy(), which I don't think guarantees enough atomicity with
concurrent updates of page->mapping or such, so dump_mapping() could
probably run on a bogus pointer. Even without torn pointers, I think
there could be a UAF if the page's mapping is destroyed while we're
going through dump_page(), since the page might not be locked. And in
dump_mapping(), the strncpy_from_kernel_nofault() also doesn't guard
against concurrent renaming of the dentry, which I think again would
probably result in UAF.
So I think dump_page() in its current form is not something we should
expose to a userspace-reachable API.

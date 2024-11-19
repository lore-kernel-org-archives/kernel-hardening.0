Return-Path: <kernel-hardening-return-21859-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BC9D8D60D06
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2024 01:30:51 +0000 (UTC)
Received: (qmail 8067 invoked by uid 550); 19 Nov 2024 01:30:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8035 invoked from network); 19 Nov 2024 01:30:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1731979832; x=1732584632; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dwhbrEEfePVbvJU2Ozddu2A4+flvh6qun9KERWZBa38=;
        b=l5IcylFQGT11B9HAI4N9uT4cZyGY8ftXwKxgDeG5+HWUna4TV/vZoa2LWz6FcEfbq5
         BRktoH8v7d7z53XIB6arrmOd9WwL1NK12oUQJEkvgcOB8v5/yobtQzGDsbHBRwRQxWK0
         AAUhQccVOEEy/CrXXEyY3l5riFMnCqNY/IKf8sBY1MtEFWpubJ2gM8wVJR2NLuXk7FMA
         FpDd0xsKbDfEk3nqxC98t6O1oUeV2m3etUt4WRFvPBoG757Z6DNsHpD1HWVlE2l0qnJ9
         gFI+0rOnvLC+TRu/A4iugcmjegCuXGZD3Q9PvbLVjyPR5I2AsO14gpezi5A4tDLjaDqt
         uWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731979832; x=1732584632;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dwhbrEEfePVbvJU2Ozddu2A4+flvh6qun9KERWZBa38=;
        b=IWX6JAdvGJW8MGJ3JLLUshYvAVcRaCliifLD8GXWHSP8Xp0OCIn50dKUnSoEPv7ccz
         /k8wk3sGxHG6clRg6X2WpLWYHxWdeUFaKoa38rOjK51tmS7PbD87I70ztEilNi0KPulS
         Avx9fogBKxZmNSMKd/JkU0JRtTCy6VlIt+zJDMjSi3S0z+sPnzsxmXWYhq96tpHLw3TD
         nYsGNJl/k+N2FJx+xF6BBHeyhhFlUohyNPcPbs3GCVBADxsroT3MrGKNk9Uy2C6pkcCO
         y2pH7Y2EJDC14PyYWzZVWTEFw38smReMKrZhqdlYeSW/RIaATCaZGWAAw02b2tnV506Y
         TQ9g==
X-Forwarded-Encrypted: i=1; AJvYcCXV5WwI59Jyy3EdeWcPPeh5/2gTv4yHryZpo991t2y9v9YKXU3QaDlEGAoUrtiwyNbEySKhxrjlmuc6JXj0EGxe@lists.openwall.com
X-Gm-Message-State: AOJu0Yw6/YNrUpU4uZqAFuYgTMSl6rr+GSOrsfIFA+GMkc1B3NLv35C3
	HsRqyB5JBoEGgbHpg8kNW++cZKair9tnD6/fgezx22nqWKi+Z0ILGHZBCvCZ1SnDjTJHElaE93R
	Z5uWqP5PiWJpcdNSggmQyosmhnZYZNWsmuObKRw==
X-Google-Smtp-Source: AGHT+IEnblF5WP9b6MMjtXTC6Vjj1Iy7OkpDZ4PeMU+Uc4InANfSMt/pice9eNGMRdH2BcrKEejfz0Ajo3xoxrMqxY0=
X-Received: by 2002:a05:6102:3f04:b0:4a9:14:3ee9 with SMTP id
 ada2fe7eead31-4ad62d52711mr12363521137.23.1731979832190; Mon, 18 Nov 2024
 17:30:32 -0800 (PST)
MIME-Version: 1.0
References: <20241116175922.3265872-1-pasha.tatashin@soleen.com>
 <a0372f7f-9a85-4d3e-ba20-b5911a8189e3@lucifer.local> <CAG48ez2vG0tr=H8csGes7HN_5HPQAh4WZU8U1G945K1GKfABPg@mail.gmail.com>
 <CA+CK2bB0w=i1z78AJbr2gZE9ybYki4Vz_s53=8URrxwyPvvB+A@mail.gmail.com> <CAG48ez1KFFXzy5qcYVZLnUEztaZxDGY2+4GvwYq7Hb=Y=3FBxQ@mail.gmail.com>
In-Reply-To: <CAG48ez1KFFXzy5qcYVZLnUEztaZxDGY2+4GvwYq7Hb=Y=3FBxQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 18 Nov 2024 20:29:55 -0500
Message-ID: <CA+CK2bCBwZFomepG-Pp6oiAwHQiKdsTLe3rYtE3hFSQ5spEDww@mail.gmail.com>
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

> Can you point me to where a refcounted reference to the page comes
> from when page_detective_metadata() calls dump_page_lvl()?

I am sorry, I remembered incorrectly, we are getting reference right
after dump_page_lvl() in page_detective_memcg() -> folio_try_get(); I
will move the folio_try_get() to before dump_page_lvl().

> > > So I think dump_page() in its current form is not something we should
> > > expose to a userspace-reachable API.
> >
> > We use dump_page() all over WARN_ONs in MM code where pages might not
> > be locked, but this is a good point, that while even the existing
> > usage might be racy, providing a user-reachable API potentially makes
> > it worse. I will see if I could add some locking before dump_page(),
> > or make a dump_page variant that does not do dump_mapping().
>
> To be clear, I am not that strongly opposed to racily reading data
> such that the data may not be internally consistent or such; but this
> is a case of racy use-after-free reads that might end up dumping
> entirely unrelated memory contents into dmesg. I think we should
> properly protect against that in an API that userspace can invoke.
> Otherwise, if we race, we might end up writing random memory contents
> into dmesg; and if we are particularly unlucky, those random memory
> contents could be PII or authentication tokens or such.
>
> I'm not entirely sure what the right approach is here; I guess it
> makes sense that when the kernel internally detects corruption,
> dump_page doesn't take references on pages it accesses to avoid
> corrupting things further. If you are looking at a page based on a
> userspace request, I guess you could access the page with the
> necessary locking to access its properties under the normal locking
> rules?

I will take reference, as we already do that for memcg purpose, but
have not included dump_page().

Thank you,
Pasha

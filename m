Return-Path: <kernel-hardening-return-22003-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 18346CA0FED
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Sep 2025 21:19:02 +0000 (UTC)
Received: (qmail 21958 invoked by uid 550); 5 Sep 2025 21:18:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21914 invoked from network); 5 Sep 2025 21:18:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757107123; x=1757711923; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ir+mQtnfx/4sLdud4ghKsNSgiyx0xtDI7KlyJXyioY=;
        b=XUecrGnT6nHwuIz3zxMoGvKkKwO/ZRoWyyqAfcx5uQlxkUaDdUOvy0O672DrUQofZX
         YrySN6kEU1QQL94ZCAVAYoWITJC0cuyxNHBzFQOhAbo8zoYIhFWQCKIr6u2jgAb/WZLn
         4F/T2npgHn8ZR4b+N3xIWr/PowzQpF167CKbwOUXKva+XOrVD82GM9fwPL4gtWL3C9bp
         8gbLTfQR0v0OczaInC9T77MsgVwbeuBBeSm0vk1pzrjkVCzrM60wJrx4UvefSDHWQp0b
         ixNAwU4awFySypH3AS9V2KoAMIYgoHxoze3S5iEU0bsGbUSplVyjdBuBjO5HkyNQ8mFj
         /oLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757107123; x=1757711923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ir+mQtnfx/4sLdud4ghKsNSgiyx0xtDI7KlyJXyioY=;
        b=iU6+9rUybO+/Q4G5FxhhZUZjJDESLaaCMu5Z9zP8PZQPqy7cOozDJ8IiJ71L9GAsil
         ykf/Nfsy6i8/xNWFZCU0tLXo4zSV/6r/26AKQIMfpE0t+k3vq2SY1gOk9FHVdKFXjU36
         q7AgHnqjXvFMLRcETQ6rn09Ww5GdLryWwiK6TN/ScjPJvf1xeHP4bJ8UuVgkGi81uiHo
         zH4iAJX1LsfR51lrJdI4mjDNx4jqEA0zHHXD7WWVTmfirvUvTDVCzU9RlYsItMRjLGvY
         bXKWyBPTSg4QrbmqLGFVE6IgF6wW47KQGtbq1Cf1+AMj3qRNXCc0Z2UxyFPn+YHKBrI0
         5mIA==
X-Gm-Message-State: AOJu0YxctjNzTqNuHmkXFtReBsqU5nYNucwAGvrHu2vfRVPqgFXbrpCz
	xdmGPM5Mdt7rxx205RSVd1AqK28faxrunR0UoJKu8F57ZS492hSYeoiqcXNH3aoplC4jMZ85TDS
	TqUtHQw0Sxp0CM45VYyApauwa8dWdthw=
X-Gm-Gg: ASbGncvDeurd85qW5NmiK8r/Li53U0kxXeey+uP9caiq4sEyn8+HktkTDx6+MtIsqB7
	fgfF3NAgZO/6JKsLWNHTEb5HyQjwfFPQyjBzmtRoA3wgM8mOR3yTzsTK7S2PHdxbJZxDXu38lvQ
	9t4RQZRcONO8K4xpMlWXhjExzne54sYZ7Hp4VZBIb1DkKDqa6jP1dK1HrNBaaC1zSISe/cTWdkB
	szjhaxskotfN1Nfuw==
X-Google-Smtp-Source: AGHT+IEgWv1D91zWSgoImbXrRcPy5ZV2Wu02ODmTl/zI9yjh7DlAkMQ9aVhZ7KPIK1OuKkXW8SeulTgQeggx/M7V3rI=
X-Received: by 2002:a05:600c:1987:b0:458:b01c:8f with SMTP id
 5b1f17b1804b1-45ddde8a55cmr3274575e9.8.1757107123278; Fri, 05 Sep 2025
 14:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <01d9ec74-27bb-4e41-9676-12ce028c503f@linux.com>
In-Reply-To: <01d9ec74-27bb-4e41-9676-12ce028c503f@linux.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Sep 2025 23:18:32 +0200
X-Gm-Features: Ac12FXxfwzu8wekZMUNPG1-5QkyVVlkCYMyrLtAYUduk-8PvduVEITzaspdDKck
Message-ID: <CA+fCnZdQDDwkcd153qexNDP-61VAbB4iAJrj02UVtoL8KN2Vjw@mail.gmail.com>
Subject: Re: Slab allocator hardening and cross-cache attacks
To: alex.popov@linux.com
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	kasan-dev <kasan-dev@googlegroups.com>, Kees Cook <keescook@chromium.org>, 
	Kees Cook <kees@kernel.org>, Jann Horn <jannh@google.com>, Marco Elver <elver@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Florent Revest <revest@google.com>, 
	GONG Ruiqi <gongruiqi1@huawei.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 10:11=E2=80=AFPM Alexander Popov <alex.popov@linux.c=
om> wrote:
>
> After experimenting with kernel-hack-drill on Ubuntu Server 24.04, I foun=
d that
> CONFIG_RANDOM_KMALLOC_CACHES and CONFIG_SLAB_BUCKETS block naive UAF
> exploitation, yet they also make my cross-cache attacks completely stable=
. It
> looks like these allocator features give an attacker better control over =
the
> slab with vulnerable objects and reduce the noise from other objects. Wou=
ld you
> agree?
>
> It seems that, without a mitigation such as SLAB_VIRTUAL, the Linux kerne=
l
> remains wide-open to cross-cache attacks.

I'd second the notion that without SLAB_VIRTUAL, the attempts to
deterministically separate objects into different caches based on the
code location or the type (as also with the TYPED_KMALLOC_CACHES
series proposed by Marco [1]) aid exploitation more than prevent it.

Many kernel exploits nowadays rely on cross-cache attacks due to the
high portability of the post-cross-cache techniques for getting code
execution or escalating privileges. And with these object separation
features, the amount of unrelated-to-the-exploit allocation noise for
a specific slab cache gets significantly reduced or completely
removed. Which makes cross-cache attacks very stable.

The only negative effect these separation features have on cross-cache
attacks is that the attacker has to use the objects coming from the
affected slab cache (i.e. the cache from where the object affected by
the exploited vulnerability is allocated) for the slab shaping during
the cross-cache attack (filling up the slab, overflowing the partial
list, etc.). In practice, this is usually not a problem: the attacker
can often allocate as many objects as they want from the affected
cache (by using the same code path as the one required to allocate the
vulnerable object) and only trigger the vulnerability for one of them.

Having said that, I think it's still worth working on these separation
features with the hope that SLAB_VIRTUAL will at some point end up in
the kernel and be affordable enough to be enabled in production.

[1] https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/

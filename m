MIME-Version: 1.0
In-Reply-To: <c6318a78ef026da30aa488bd90a5a19e18fc13a3.1495156488.git.mchehab@s-opensource.com>
References: <cover.1495156488.git.mchehab@s-opensource.com> <c6318a78ef026da30aa488bd90a5a19e18fc13a3.1495156488.git.mchehab@s-opensource.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 May 2017 10:35:42 -0700
Message-ID: <CAGXu5jKyZEV+mvJUipfX5GMFqv=HYLoU-9C_1pYrc24J-0YaWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 23/31] gcc-plugins.txt: standardize document format
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Richard Weinberger <richard@nod.at>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Linux mtd <linux-mtd@lists.infradead.org>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 18, 2017 at 6:22 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Each text file under Documentation follows a different
> format. Some doesn't even have titles!
>
> Change its representation to follow the adopted standard,
> using ReST markups for it to be parseable by Sphinx:
>
> - promote main title;
> - use the right markup for footnotes;
> - use bold markup for files name;
> - identify literal blocks;
> - add blank lines to avoid Sphinx to complain;
> - remove numeration from titles.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Kees Cook <keescook@chromium.org>

This should probably get moved under "Kernel API documentation" but
may need a new sub-category, maybe "instrumentation"? Things like
KASan could be put under that too.

-Kees

-- 
Kees Cook
Pixel Security

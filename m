MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <956283e0d9f9c01a437ab75c5c9a324959ead132.1497713142.git.mchehab@s-opensource.com>
References: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab@s-opensource.com>
 <956283e0d9f9c01a437ab75c5c9a324959ead132.1497713142.git.mchehab@s-opensource.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 11:58:24 -0700
Message-ID: <CAGXu5jKeFVtj1ZmMW7CuZFv_QemnTG8q5jyQo7Q5ppi-AZ+MXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 22/31] gcc-plugins.txt: standardize document format
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 17, 2017 at 8:25 AM, Mauro Carvalho Chehab
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

Thanks! This should maybe get moved/indexed in dev-tools/. What do you think?

Regardless:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security

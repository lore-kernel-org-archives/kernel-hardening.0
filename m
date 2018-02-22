MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180222231442.29507-1-labbott@redhat.com>
References: <22f5c157-8b01-5e0a-69e1-44939cc73d7e@redhat.com> <20180222231442.29507-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 22 Feb 2018 15:43:55 -0800
Message-ID: <CAGXu5jKH3E3w6D70gfrZiCcXW04Bc-i+kU-HDVJLXkoJaS7RkQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Update stackleak for gcc-8
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 22, 2018 at 3:14 PM, Laura Abbott <labbott@redhat.com> wrote:
>
> Okay I _think_ this should be the solution for gcc-8. I've split this
> into two patches, one for the generic framework and the other for the
> stackleak plugin itself.

Nice! Thanks for solving this!

> Kees, I'll let you figure out how to apply
> these. Feel free to fold in as appropriate.

Other than the suggestion to have fewer ifdef in stackleak, this looks
fine. Alexander, feel free to take these both (with adjustments) for
the stackleak series: stackleak is the only user of
cgraph_create_edge() so I think it's fine to adjust gcc-common.h in
the series.

-Kees

-- 
Kees Cook
Pixel Security

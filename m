MIME-Version: 1.0
In-Reply-To: <CAGXu5jLGLAWeQ28t3TiRswbfHM9F0odZia-f=-c5sVpYm+-0UA@mail.gmail.com>
References: <1509580240-28314-1-git-send-email-me@tobin.cc> <CAGXu5jLGLAWeQ28t3TiRswbfHM9F0odZia-f=-c5sVpYm+-0UA@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 8 Nov 2017 15:04:25 -0800
Message-ID: <CAKwvOdm72j2MQPbXY5eYLj5r-9toOJd+GB2=P6z1_L7SghazZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC] vla: add VLA macro and testing
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 8, 2017 at 2:58 PM, Kees Cook <keescook@chromium.org> wrote:
> While I'd certainly like to see SOME kind of sanity checking for VLAs,
> my preference would be to entirely eliminate them at get -Werror=vla
> added to the Makefile. Even Linus has expressed irritation over the
> idea of VLAs in structs in the past:
>
> https://lkml.org/lkml/2013/9/23/500

VLAIS makes it difficult (impossible) to compile allyesconfig with
clang.  VLA on the stack is fine, but VLAIS is not.

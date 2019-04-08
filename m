MIME-Version: 1.0
References: <20190308132701.133598-1-glider@google.com> <20190308132701.133598-3-glider@google.com>
 <497b1201-b2ae-5e0c-d191-ff1830d92fc1@redhat.com>
In-Reply-To: <497b1201-b2ae-5e0c-d191-ff1830d92fc1@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 8 Apr 2019 10:14:45 -0700
Message-ID: <CAGXu5jJUWKiyW-_ygHpg9rJc7wQ2XTzjH71CtJfdefLu2zZHEg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Potapenko <glider@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 8, 2019 at 9:43 AM Laura Abbott <labbott@redhat.com> wrote:
> I've looked at doing something similar in the past (failing to find
> the thread this morning...) and while this will work, it has pretty
> serious performance issues. It's not actually the poisoning which
> is expensive but that turning on debugging removes the cpu slab
> which has significant performance penalties.
>
> I'd rather go back to the proposal of just poisoning the slab
> at alloc/free without using SLAB_POISON.

I still agree this would make the most sense. Fundamentally it's not a
debugging feature.

-- 
Kees Cook

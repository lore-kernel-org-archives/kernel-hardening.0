MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org> <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2018 10:29:16 -0700
Message-ID: <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Florian Weimer <fweimer@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 4:47 AM, Florian Weimer <fweimer@redhat.com> wrote:
>
> If you want to catch stack frames which have unbounded size,
> -Werror=3Dstack-usage=3D1000 or -Werror=3Dvla-larger-than=3D1000 (with th=
e constant
> adjusted as needed) might be the better approach.

No, we want to catch *variable* stack sizes.

Does "-Werror=3Dvla-larger-than=3D0" perhaps work for that? No, because
the stupid compiler says that is "meaningless".

And no, using "-Werror=3Dvla-larger-than=3D1" doesn't work either, because
the moronic compiler continues to think that "vla" is about the
_type_, not the code:

   t.c: In function =E2=80=98test=E2=80=99:
   t.c:6:6: error: argument to variable-length array is too large
[-Werror=3Dvla-larger-than=3D]
     int array[(1,100)];

Gcc people are crazy.

Is there really no way to just say "shut up about the stupid _syntax_
issue that is entirely irrelevant, and give us the _code_ issue".

                 Linus

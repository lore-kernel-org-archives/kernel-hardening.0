MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com> <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk> <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 17 Mar 2018 00:27:02 -0700
Message-ID: <CAGXu5jJmAAgaq3VCsUN2yjpHLSc7P-kNrM_4c4cqP=ysFcETXA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Florian Weimer <fweimer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 12:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Kees - is there some online "gcc-4.4 checker" somewhere? This does
> seem to work with my gcc. I actually tested some of those files you
> pointed at now.

Unfortunately my 4.4 test fails quickly:

./include/linux/jiffies.h: In function =E2=80=98jiffies_delta_to_clock_t=E2=
=80=99:
./include/linux/jiffies.h:444: error: first argument to
=E2=80=98__builtin_choose_expr=E2=80=99 not a constant

static inline clock_t jiffies_delta_to_clock_t(long delta)
{
        return jiffies_to_clock_t(max(0L, delta));
}

I think this is the same problem of using __builtin_constant_p() in
4.4 that we hit earlier? :(

-Kees

--=20
Kees Cook
Pixel Security

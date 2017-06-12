MIME-Version: 1.0
In-Reply-To: <1497286620-15027-2-git-send-email-s.mesoraca16@gmail.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com> <1497286620-15027-2-git-send-email-s.mesoraca16@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 12 Jun 2017 19:49:13 +0200
Message-ID: <CAG48ez1DBG9cwGtcwKmrL9tSfi4vvNk-X07jnUmzv81RM4Po_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 01/11] S.A.R.A. Documentation
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 12, 2017 at 6:56 PM, Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> Adding documentation for S.A.R.A. LSM.
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
[...]
> +/proc/PID/attr/sara/wxprot interface
> +------------------------------------
> +The `procattr` interface can be used by a program to discover which
> +WX Protection features are enabled and/or to tighten them: protection
> +can't be softened via procattr.
> +The interface is simple: it's a text file with an hexadecimal
> +number in it representing enabled features (more information can be
> +found in the `Flags values`_ section). Via this interface it is also
> +possible to perform a complete memory scan to remove the write permission
> +from pages that are both writable and executable.
> +
> +Protections that prevent the runtime creation of executable code
> +can be troublesome for all those programs that actually need to do it
> +e.g. programs shipping with a JIT compiler built-in.
> +Given that it's possible to segregate the part that runs untrusted
> +code from the rest through a fork, this feature can be use to run the JIT
> +compiler with few restrictions while enforcing full WX Protection in the
> +rest of the program.

As far as I can tell, the wxprot interface in procfs, when used as
/proc/PID/attr/sara/wxprot, actually only sets restrictions on one of the
threads.
The documentation doesn't seem to mention this.


> +.. [3] `saralib                <https://github.com/smeso/saralib>`_

This link is broken.

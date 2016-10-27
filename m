Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1477071466-19256-1-git-send-email-michael.leibowitz@intel.com>
References: <1477071466-19256-1-git-send-email-michael.leibowitz@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 27 Oct 2016 16:01:25 -0700
Message-ID: <CAGXu5j+R4stGdd1Prg5-vD6K609dNdDSRAfhDNoE0-jkSRBpVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Add the randstruct gcc plugin
To: Michael Leibowitz <michael.leibowitz@intel.com>
Cc: Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 21, 2016 at 10:37 AM, Michael Leibowitz
<michael.leibowitz@intel.com> wrote:
> This plugin randomizes the layout of certain structures at compile

"allows for the randomization of"... :)

> time.  This introduces two defines __randomize_layout and
> __no_randomize_layout.  Which, in turn, tell the compiler to either
> try to randomize or not to randomize the struct in question.
>
> This feature is ported over from grsecurity.  The implementation is
> nearly identical to the original code written by the PaX Team and
> Spender.  To make integration simpler, this version only supports
> explicit marking of structures.  However, it retains the
> __no_randomize_layout support for the future.
>
> The UAPI checks are
> retained as well.  Structures that are to be randomized are required
> to use the C99 designated initializer form.
>
> Signed-off-by: Michael Leibowitz <michael.leibowitz@intel.com>

In the earlier thread, I suggested a series that looked like this:

- plugin itself (minus all-function-pointers)
- opt-in markings
- C99 changes
- out-out markings
- all-function-pointers plugin logic

It sounds like this is the first step of that idea -- what was changed
to remove the auto-marking logic?

(Also, this needs extensive 80-char wrapping done... see how close you
can get it to be scripts/checkpatch.pl clean...)

Thanks for the update!

-Kees

-- 
Kees Cook
Nexus Security

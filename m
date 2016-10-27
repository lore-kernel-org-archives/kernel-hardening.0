Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+O1YZZ1k6xVvp=xJkpqMXr0c5ADjPYCS0TdVvuJ0-1vg@mail.gmail.com>
References: <1477071466-19256-1-git-send-email-michael.leibowitz@intel.com> <CAGXu5j+O1YZZ1k6xVvp=xJkpqMXr0c5ADjPYCS0TdVvuJ0-1vg@mail.gmail.com>
From: "Leibowitz, Michael" <michael.leibowitz@intel.com>
Date: Thu, 27 Oct 2016 16:32:01 -0700
Message-ID: <CAB-iPKVNnFapLHNinH+SAtAcGbAdJC7DSNHzgEUu1rd1hBJCtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Add the randstruct gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 4:15 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Oct 21, 2016 at 10:37 AM, Michael Leibowitz
> <michael.leibowitz@intel.com> wrote:
>> This plugin randomizes the layout of certain structures at compile
>> time.  This introduces two defines __randomize_layout and
>> __no_randomize_layout.  Which, in turn, tell the compiler to either
>> try to randomize or not to randomize the struct in question.
>
> How are you testing this, btw? I manually marked struct cred with
> __randomize_layout, and "pahole vmlinux" shows it is not randomized...

I made a module that defined several fields and printed their layout
in memory.  It was out of order with it marked.  I haven't tried it on
the cred struct.  I will do so.

Cheers

>
> -Kees
>
> --
> Kees Cook
> Nexus Security



-- 
Michael Leibowitz

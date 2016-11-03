Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161103182441.GA29904@laptop.thejh.net>
References: <1478187038-19954-2-git-send-email-wluikil@gmail.com> <20161103182441.GA29904@laptop.thejh.net>
From: Lafcadio Wluiki <wluikil@gmail.com>
Date: Thu, 3 Nov 2016 14:21:41 -0600
Message-ID: <CAOWbf6e7V77TpUYJwRdmD9vyeqA14hbL-HZqweTEign-hUSKiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [2/2] procfs/tasks: add a simple per-task procfs hidepid= field
To: Jann Horn <jann@thejh.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 3, 2016 at 12:24 PM, Jann Horn <jann@thejh.net> wrote:

>> +     case PR_SET_HIDEPID:
>> +             if (arg2 < HIDEPID_OFF || arg2 > HIDEPID_INVISIBLE)
>> +                     return -EINVAL;
>> +             if (arg2 < me->hide_pid)
>> +                     return -EPERM;
>> +             me->hide_pid = arg2;
>> +             break;
>
> Should we test for ns_capable(CAP_SYS_ADMIN)||no_new_privs here?
> I think it wouldn't hurt, and I'd like to avoid adding new ways in which
> the execution of setuid programs can be influenced. OTOH, people already
> use hidepid now, and it's not an issue... I'm not sure. Opinions?

Hmm, the existing hidepid= thing is a mount option and that you you of
course can only change with root privs so far, hence the NNP thing
doesn't really apply so far on hidepid.

> @Lafcadio: Do you think that requiring no_new_privs to be set would
> break your usecase? Would nginx need to still be able to execute setuid
> binaries?

I think adding the NNP check would be OK for my use. I'll add this to
the next iteration!

> Aside from this, and the comments Kees already made, this looks good
> to me.

Thanks for the review,

L.

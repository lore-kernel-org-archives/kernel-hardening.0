MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1491517947.8850.162.camel@redhat.com>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
 <alpine.LRH.2.20.1704070749440.27111@namei.org> <1491517947.8850.162.camel@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 6 Apr 2017 15:51:30 -0700
Message-ID: <CAGXu5jKgK0MHbGekyCEXHJvZjgHh2oB+TABmeuH-1MH9fdCWFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 00/18] Introduce struct layout
 randomization plugin
To: Rik van Riel <riel@redhat.com>
Cc: James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 6, 2017 at 3:32 PM, Rik van Riel <riel@redhat.com> wrote:
> On Fri, 2017-04-07 at 07:54 +1000, James Morris wrote:
>> On Thu, 6 Apr 2017, Kees Cook wrote:
>>
>> > third party kernel module builds), it still has some value there
>> > since
>> > now all kernel builds would need to be tracked by an attacker.
>>
>> I don't see this case as providing any value.  Tracking a bunch of
>> known
>> seed values seems like a pretty low bar for an attacker.
>
> I agree this is not likely to provide much value for users
> of distribution kernels.
>
> One possible exception might be if Google started distributing
> dozens, or hundreds, of kernel variants randomly to users of
> Nexus devices, and nobody knew which variant each device was
> running.

Right, or in the distribution case, rebuilding distro kernels instead
of using the binary packages.

-Kees

-- 
Kees Cook
Pixel Security

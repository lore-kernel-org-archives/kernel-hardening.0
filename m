Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
Date: Tue, 19 Jan 2016 10:11:00 -0800
Message-ID: <CAGXu5jL5JV2WS2GVuL16N82DYGVqshveOfWs=iTzH+1XeuSiaA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,

On Fri, Nov 6, 2015 at 2:55 PM, Emese Revfy <re.emese@gmail.com> wrote:
>  * constify: This plugin constifies all structure types which contain only
>     function pointers or are explicitly marked for constification.
>     If some code wants to modify a read-only object it will cause
>     a compile error.
>     There are two gcc attributes:
>        * no_const: if we don't want constification
>        * do_const: if we want to constify a structure type which has a
>           non-function pointer field

Can you give a status update on the constify plugin work? I'm curious
to hear what your plans are.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

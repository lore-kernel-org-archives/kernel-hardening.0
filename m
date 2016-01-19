Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160119112812.GA10818@mwanda>
References: <20160119112812.GA10818@mwanda>
Date: Tue, 19 Jan 2016 15:35:03 -0800
Message-ID: <CAGXu5jK8rfT8sPvJ5thrD4Abb7jFG=PVMzJB6SBkQKU33Dzq1A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 3:28 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Many of the use-after-free and uninitialized data bugs would be less
> harmful if we had some kernel hardening patches.

I think this nicely underscores the importance of all the hardening
efforts, especially Laura's PAX_MEMORY_SANITIZE port. And with the
recent keyring issue, having David's PAX_REFCOUNT port too. It's all
coming along (slowly). :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFzZVL=WVuhJAQDazj59jwnmhUrRRwNgzXS+c-q5yva0iw@mail.gmail.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632014097.21271.16980532033566583357.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180206192925.qkmghwsbaysr4iv2@hermes.olymp> <CAPcyv4ihN6fy5-vBtfA0PuwXvCAj8-rMhtQmevh5sdYxbH3Yfw@mail.gmail.com>
 <CA+55aFxYHX3=HN4P5M0ziSJ08WfjccyhE2T7epS-EC6ZJ6LyjQ@mail.gmail.com>
 <CAPcyv4i5oORdk-Fzypxw_+gCLUa8f=w1e_n0=47P7uHR-jT6GQ@mail.gmail.com> <CA+55aFzZVL=WVuhJAQDazj59jwnmhUrRRwNgzXS+c-q5yva0iw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Feb 2018 12:43:19 -0800
Message-ID: <CA+55aFziKW3=R4erPJ_35JbWv5P02qqqnmS8zDR1mn=+M-YXQw@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] x86: narrow out of bounds syscalls to sys_read
 under speculation
Content-Type: text/plain; charset="UTF-8"
To: Dan Williams <dan.j.williams@intel.com>
Cc: Luis Henriques <lhenriques@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 6, 2018 at 12:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Sadly, that is *very* easy to miscompile.

Side note: don't read email, go watch the falcon heavy takeoff.

              Linus

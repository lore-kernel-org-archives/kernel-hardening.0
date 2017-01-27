References: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>
 <CAGXu5jKrU5GR3KDb9M-vtSpY+aRm2B0vGpahVYLtFTWs=g7Big@mail.gmail.com>
 <f5ea8825-532c-93bd-d51d-6ec1e541fae6@au1.ibm.com>
 <584A8E9E.22035.590FC72@pageexec.freemail.hu>
 <25e3a510-1652-5be9-cc26-24d35f9ac95e@au1.ibm.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Fri, 27 Jan 2017 16:55:37 +1100
MIME-Version: 1.0
In-Reply-To: <25e3a510-1652-5be9-cc26-24d35f9ac95e@au1.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <abbe5484-b546-6987-de5f-c0070657efba@au1.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] powerpc: enable support for GCC plugins
To: pageexec@freemail.hu, Kees Cook <keescook@chromium.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 27/01/17 16:52, Andrew Donnellan wrote:
> basic-block.h includes tm.h, and I don't believe we can remove that. I'm
> not convinced there's a way around this.

Includes via function.h, I should say.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

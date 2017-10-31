MIME-Version: 1.0
Sender: hansendc@gmail.com
In-Reply-To: <1494343857.20270.23.camel@redhat.com>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
 <20170504154717.GA24353@infradead.org> <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
 <CAFLxGvwuMN52-Xf46j7XuG+cnJ9xnZjXWhihpgxr9_EUX0Z+Bg@mail.gmail.com>
 <cc75a38a-4ea6-e300-0370-882dfbfd7a23@iaik.tugraz.at> <6013bf3f-c3bd-3836-e5e2-ea89cc2e556a@nod.at>
 <8aecf7d4-9767-5367-1bc0-75fbd4b17e46@iaik.tugraz.at> <07322e2c-e95f-ea35-bc1f-7b05c082e287@gdata-adan.de>
 <22a14b06-9489-3494-bbb7-428d4e5fa186@nod.at> <1494343857.20270.23.camel@redhat.com>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 31 Oct 2017 16:28:20 -0700
Message-ID: <CABq-xd34jdmjMWn5ZM6Mj-N5tZqTObhJJmhy7LgmkQTQVWH7pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not
 mapkernel in user mode
To: Rik van Riel <riel@redhat.com>
Cc: Richard Weinberger <richard@nod.at>, "Fogh, Anders" <anders.fogh@gdata-adan.de>, Daniel Gruss <daniel.gruss@iaik.tugraz.at>, Christoph Hellwig <hch@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Folks,

I've fixed some bugs and updated the KAISER patch set on top of the
work that was done here.  My new version is posted here:

https://marc.info/?l=linux-kernel&m=150948911429162&w=2

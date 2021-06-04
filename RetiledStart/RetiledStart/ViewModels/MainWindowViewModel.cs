// RetiledStart - Windows Phone 8.x-like Start screen UI for the
//                Retiled project.
// Copyright (C) 2021 Drew Naylor
// (Note that the copyright years include the years left out by the hyphen.)
// Windows Phone and all other related copyrights and trademarks are property
// of Microsoft Corporation. All rights reserved.
//
// This file is a part of the Retiled project.
// Neither Retiled nor Drew Naylor are associated with Microsoft
// and Microsoft does not endorse Retiled.
// Any other copyrights and trademarks belong to their
// respective people and companies/organizations.
//
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.




using ReactiveUI;
using System;
using System.Collections.Generic;
using System.Text;

namespace RetiledStart.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {

        // Wire up the All Apps view according to
        // this tutorial page: https://docs.avaloniaui.net/tutorials/todo-list-app/adding-new-items
        ViewModelBase content;

        // Make a view model thing.
        public MainWindowViewModel()
        {
            // Set default view model.
            Content = RetiledStartScreen = new RetiledStartScreenViewModel();
        }

        // Set up the capitalised "Content" thing.
        // Might be a property since it has "get" and "set".
        public ViewModelBase Content
        {
            // Set the capitalised "Content" to the
            // lowercased "content".
            get => content;
            private set => this.RaiseAndSetIfChanged(ref content, value);
        }

        // Set up the Start screen thing.
        public RetiledStartScreenViewModel RetiledStartScreen { get; }

        // Set up the part that goes to the All Apps list.
        public void ShowAllAppsList()
        {
            Content = new RetiledStartScreenViewModel
        }


        public string Greeting => "cobalt-colored tile";
        // Cobalt was #0050ef according to W3Schools, but it doesn't look quite right
        // in Avalonia. Not sure how to make it look exactly like it did on my Lumia 822 and 830,
        // because that's the real version of cobalt to me.
        // #0047ab may be better, as that's what shows up when I type "cobalt" into
        // ColorHexa.
        // Tested the code from ColorHexa and it looks too dull.
    }
}
